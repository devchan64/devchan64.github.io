import argparse
import hashlib
import json
import os
import re
import time
from pathlib import Path
from datetime import datetime, timezone

import yaml


MODEL = os.getenv("OPENAI_TRANSLATE_MODEL", "gpt-4.1")
API_KEY = os.getenv("OPENAI_API_KEY")
NOTICE = "> This article was translated from the original Korean source. The English version was regenerated from the latest Korean document.\n\n---\n\n"
MAX_CHARS_PER_CHUNK = 6000
RETRY_LIMIT = 3

BASELINE_TAGS = [
    "Project",
    "Design Philosophy",
    "Leadership",
    "Technical Debt",
    "Organizational Culture",
    "Knowledge Base",
    "Memory Management",
    "Onboarding",
    "Retrospective",
]

client = None


def split_front_matter(text: str):
    match = re.match(r"^(---\n.*?\n---\n)(.*)$", text, re.DOTALL)
    if not match:
        return "", text, {}

    front_raw, body = match.groups()
    front_dict = yaml.safe_load(front_raw.strip("-\n")) or {}
    return front_raw, body, front_dict


def reconstruct_front_matter(front_dict: dict) -> str:
    return "---\n" + yaml.dump(front_dict, allow_unicode=True, sort_keys=False) + "---\n"


def compute_sha256(text: str) -> str:
    return hashlib.sha256(text.encode("utf-8")).hexdigest()


def call_model(messages, temperature=0.2) -> str:
    global client
    if client is None:
        from openai import OpenAI

        client = OpenAI(api_key=API_KEY)

    last_error = None
    for attempt in range(1, RETRY_LIMIT + 1):
        try:
            response = client.chat.completions.create(
                model=MODEL,
                messages=messages,
                temperature=temperature,
            )
            content = response.choices[0].message.content
            if not content:
                raise RuntimeError("Empty model response")
            return content.strip()
        except Exception as exc:  # noqa: BLE001
            last_error = exc
            if attempt == RETRY_LIMIT:
                raise
            time.sleep(attempt)
    raise RuntimeError(f"Translation failed: {last_error}")


def translate_title(text: str) -> str:
    prompt = (
        "Translate the following Korean blog post title into natural, concise English.\n"
        "Do not add quotation marks.\n\n"
        f"{text}"
    )
    return call_model([{"role": "user", "content": prompt}], temperature=0.3)


def translate_tags(tags: list[str]) -> list[str]:
    prompt = (
        "Translate the following Korean technical blog tags into natural English.\n"
        "If the meaning is close to one of these standardized tags, use that exact term.\n"
        f"Standardized tags: {', '.join(BASELINE_TAGS)}\n"
        "Return strict JSON with the shape {\"tags\": [\"...\"]} and preserve the tag count.\n\n"
        f"Source tags: {json.dumps(tags, ensure_ascii=False)}"
    )
    response = call_model([{"role": "user", "content": prompt}], temperature=0.2)
    data = json.loads(response)
    result = data["tags"]
    if len(result) != len(tags):
        raise ValueError("Translated tag count does not match source tag count")
    return result


def generate_permalink(post: Path) -> str:
    filename = post.stem
    year, month, day, *slug_parts = filename.split("-")
    if not slug_parts:
        raise ValueError(f"Invalid post filename format: {post.name}")
    slug = "-".join(slug_parts)
    return f"/en/{year}/{month}/{day}/{slug}.html"


def count_headings(text: str) -> int:
    return sum(1 for line in text.splitlines() if re.match(r"^\s{0,3}#{1,6}\s", line))


def count_code_fences(text: str) -> int:
    return sum(1 for line in text.splitlines() if line.strip().startswith("```"))


def split_large_paragraph_block(block: str, max_chars: int) -> list[str]:
    if len(block) <= max_chars:
        return [block]

    parts = []
    current = []
    current_len = 0
    for paragraph in re.split(r"(\n\s*\n)", block):
        if not paragraph:
            continue
        if current and current_len + len(paragraph) > max_chars:
            parts.append("".join(current))
            current = [paragraph]
            current_len = len(paragraph)
        else:
            current.append(paragraph)
            current_len += len(paragraph)
    if current:
        parts.append("".join(current))
    return parts


def chunk_markdown(text: str, max_chars: int = MAX_CHARS_PER_CHUNK) -> list[str]:
    lines = text.splitlines(keepends=True)
    chunks = []
    current = []
    current_len = 0
    in_code_block = False

    def flush():
        nonlocal current, current_len
        if current:
            chunk = "".join(current).strip("\n")
            if chunk:
                chunks.append(chunk + "\n")
        current = []
        current_len = 0

    for line in lines:
        stripped = line.strip()
        if stripped.startswith("```"):
            in_code_block = not in_code_block

        is_heading = (not in_code_block) and bool(re.match(r"^\s{0,3}#{1,6}\s", line))

        if is_heading and current_len >= max_chars:
            flush()

        if current and current_len + len(line) > max_chars and not in_code_block:
            flush()

        current.append(line)
        current_len += len(line)

    flush()

    final_chunks = []
    for chunk in chunks:
        if len(chunk) <= max_chars:
            final_chunks.append(chunk)
            continue
        final_chunks.extend(split_large_paragraph_block(chunk, max_chars))

    return final_chunks


def translate_body_chunk(chunk: str, chunk_index: int, total_chunks: int) -> str:
    prompt = (
        "Translate the following Korean Markdown into fluent English.\n"
        "Requirements:\n"
        "- Do not omit, summarize, or compress any content.\n"
        "- Preserve all Markdown structure, heading levels, tables, lists, block quotes, and horizontal rules.\n"
        "- Preserve fenced code blocks exactly. Do not translate code, shell commands, Mermaid blocks, filenames, or URLs.\n"
        "- Translate only natural-language prose outside fenced code blocks.\n"
        "- Keep paragraph order unchanged.\n"
        "- Return only the translated Markdown.\n\n"
        f"Chunk {chunk_index} of {total_chunks}:\n\n{chunk}"
    )
    return call_model([{"role": "user", "content": prompt}], temperature=0.2)


def translate_body(text: str) -> str:
    chunks = chunk_markdown(text)
    translated_chunks = []
    total = len(chunks)

    for index, chunk in enumerate(chunks, start=1):
        translated_chunks.append(translate_body_chunk(chunk, index, total).rstrip() + "\n")

    return "\n".join(part.rstrip() for part in translated_chunks).rstrip() + "\n"


def verify_translation(source_body: str, translated_body: str, path: Path) -> None:
    source_headings = count_headings(source_body)
    translated_headings = count_headings(translated_body)
    source_fences = count_code_fences(source_body)
    translated_fences = count_code_fences(translated_body)

    if translated_headings < source_headings:
        raise ValueError(
            f"{path.name}: translated heading count dropped ({translated_headings} < {source_headings})"
        )

    if translated_fences != source_fences:
        raise ValueError(
            f"{path.name}: code fence count changed ({translated_fences} != {source_fences})"
        )


def load_translated_front_matter(target_path: Path) -> tuple[dict, str]:
    text = target_path.read_text(encoding="utf-8")
    _, body, front = split_front_matter(text)
    return front, body


def get_stale_source_files(src_dir: Path, target_dir: Path) -> list[Path]:
    stale = []
    for source_path in sorted(src_dir.glob("*.md")):
        target_path = target_dir / source_path.name
        if not target_path.exists():
            continue

        source_text = source_path.read_text(encoding="utf-8")
        _, source_body, _ = split_front_matter(source_text)
        source_sha = compute_sha256(source_body)

        target_front, _ = load_translated_front_matter(target_path)
        target_sha = target_front.get("translation_source_sha256")

        if target_sha != source_sha:
            stale.append(source_path)

    return stale


def build_translation_report(source_path: Path, target_path: Path) -> dict:
    source_text = source_path.read_text(encoding="utf-8")
    target_text = target_path.read_text(encoding="utf-8")
    _, source_body, _ = split_front_matter(source_text)
    _, target_body, _ = split_front_matter(target_text)

    # Remove the standard notice if present before comparing body structure.
    comparable_target_body = target_body
    if comparable_target_body.startswith(NOTICE):
        comparable_target_body = comparable_target_body[len(NOTICE) :]

    source_lines = source_body.count("\n") + 1
    target_lines = comparable_target_body.count("\n") + 1
    source_chars = len(source_body)
    target_chars = len(comparable_target_body)
    source_headings = count_headings(source_body)
    target_headings = count_headings(comparable_target_body)
    source_fences = count_code_fences(source_body)
    target_fences = count_code_fences(comparable_target_body)
    line_ratio = target_lines / source_lines if source_lines else 0.0
    estimated_chunks = len(chunk_markdown(source_body))

    flags = []
    if line_ratio < 0.75:
        flags.append("low_line_ratio")
    if target_headings < source_headings:
        flags.append("missing_headings")
    if target_fences != source_fences:
        flags.append("code_fence_mismatch")

    return {
        "file": source_path.name,
        "source_lines": source_lines,
        "target_lines": target_lines,
        "source_chars": source_chars,
        "target_chars": target_chars,
        "line_ratio": round(line_ratio, 3),
        "estimated_chunks": estimated_chunks,
        "source_headings": source_headings,
        "target_headings": target_headings,
        "source_code_fences": source_fences,
        "target_code_fences": target_fences,
        "flags": flags,
    }


def verify_existing_translations(src_dir: Path, target_dir: Path, selected_files: list[str] | None = None) -> int:
    summary = collect_translation_reports(src_dir, target_dir, selected_files=selected_files)
    reports_sorted = summary["reports"]

    for report in reports_sorted:
        marker = "WARN" if report["flags"] else "OK"
        flags = ",".join(report["flags"]) if report["flags"] else "-"
        print(
            f"[{marker}] {report['file']} "
            f"ratio={report['line_ratio']:.3f} "
            f"chars={report['source_chars']} "
            f"chunks={report['estimated_chunks']} "
            f"headings={report['target_headings']}/{report['source_headings']} "
            f"fences={report['target_code_fences']}/{report['source_code_fences']} "
            f"flags={flags}"
        )

    for name in summary["missing_files"]:
        print(f"[MISS] {name} has no translated file")

    print(
        f"\nSummary: {summary['compared_count']} compared, "
        f"{summary['flagged_count']} flagged, {summary['missing_count']} missing, "
        f"estimated flagged chunks={summary['estimated_flagged_chunks']}"
    )
    return 1 if summary["flagged_count"] or summary["missing_count"] else 0


def collect_translation_reports(
    src_dir: Path, target_dir: Path, selected_files: list[str] | None = None
) -> dict:
    reports = []
    missing = []

    for source_path in get_source_files(src_dir, selected_files=selected_files):
        target_path = target_dir / source_path.name
        if not target_path.exists():
            missing.append(source_path.name)
            continue
        reports.append(build_translation_report(source_path, target_path))

    flagged = [report for report in reports if report["flags"]]
    return {
        "compared_count": len(reports),
        "flagged_count": len(flagged),
        "missing_count": len(missing),
        "missing_files": missing,
        "flagged_files": [report["file"] for report in flagged],
        "estimated_flagged_source_chars": sum(report["source_chars"] for report in flagged),
        "estimated_flagged_chunks": sum(report["estimated_chunks"] for report in flagged),
        "reports": sorted(
            reports,
            key=lambda item: (
                bool(item["flags"]),
                item["line_ratio"],
                item["file"],
            ),
        ),
    }


def write_report_json(report_path: str, report: dict) -> None:
    path = Path(report_path)
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(
        json.dumps(report, ensure_ascii=False, indent=2) + "\n",
        encoding="utf-8",
    )


def get_source_files(src_dir: Path, selected_files: list[str] | None = None) -> list[Path]:
    if not selected_files:
        return sorted(src_dir.glob("*.md"))

    files = []
    for raw in selected_files:
        name = Path(raw).name
        path = src_dir / name
        if not path.exists():
            raise FileNotFoundError(f"Source post not found: {path}")
        files.append(path)
    return sorted(files)


def clean_target_dir(target_dir: Path) -> None:
    if not target_dir.exists():
        target_dir.mkdir(parents=True, exist_ok=True)
        return

    for path in target_dir.glob("*.md"):
        path.unlink()


def translate_file(path: Path, target_dir: Path, overwrite: bool) -> None:
    output_path = target_dir / path.name
    if output_path.exists() and not overwrite:
        print(f"[SKIP] Exists: {output_path}")
        return

    content = path.read_text(encoding="utf-8")
    _, body, front_dict = split_front_matter(content)

    if "title" in front_dict:
        front_dict["title"] = translate_title(front_dict["title"])

    if "tags" in front_dict and isinstance(front_dict["tags"], list):
        front_dict["tags"] = translate_tags(front_dict["tags"])

    front_dict["permalink"] = generate_permalink(path)
    front_dict["translation_source_path"] = str(path)
    front_dict["translation_source_sha256"] = compute_sha256(body)
    front_dict["translation_model"] = MODEL
    front_dict["translation_generated_at"] = datetime.now(timezone.utc).isoformat()

    translated_body = translate_body(body)
    verify_translation(body, translated_body, path)

    new_front = reconstruct_front_matter(front_dict)
    output_path.parent.mkdir(parents=True, exist_ok=True)
    output_path.write_text(new_front + NOTICE + translated_body, encoding="utf-8")

    src_lines = body.count("\n") + 1
    dst_lines = translated_body.count("\n") + 1
    print(f"[OK] {path.name} -> {output_path} ({src_lines} source lines, {dst_lines} translated lines)")


def translate_files(
    files: list[Path],
    target_dir: Path,
    overwrite: bool,
    continue_on_error: bool,
) -> dict:
    translated = []
    failed = []

    for path in files:
        try:
            translate_file(path, target_dir, overwrite=overwrite)
            translated.append(path.name)
        except Exception as exc:  # noqa: BLE001
            failed.append({"file": path.name, "error": str(exc)})
            print(f"[FAIL] {path.name}: {exc}")
            if not continue_on_error:
                raise

    return {
        "translated_count": len(translated),
        "failed_count": len(failed),
        "translated_files": translated,
        "failed_files": failed,
    }


def get_flagged_or_missing_source_files(
    src_dir: Path,
    target_dir: Path,
    flagged_order: str,
) -> list[Path]:
    report = collect_translation_reports(src_dir, target_dir)
    report_map = {item["file"]: item for item in report["reports"]}
    names = sorted(set(report["flagged_files"] + report["missing_files"]))

    def sort_key(name: str):
        item = report_map.get(name)
        if item is None:
            source_path = src_dir / name
            source_text = source_path.read_text(encoding="utf-8")
            _, source_body, _ = split_front_matter(source_text)
            estimated_chunks = len(chunk_markdown(source_body))
            source_chars = len(source_body)
        else:
            estimated_chunks = item["estimated_chunks"]
            source_chars = item["source_chars"]

        if flagged_order == "largest":
            return (-estimated_chunks, -source_chars, name)
        if flagged_order == "name":
            return (name,)
        return (estimated_chunks, source_chars, name)

    return [src_dir / name for name in sorted(names, key=sort_key)]


def get_targeted_source_files(
    src_dir: Path,
    target_dir: Path,
    selected_files: list[str] | None,
    translate_flagged: bool,
    translate_stale: bool,
    flagged_order: str,
) -> list[Path]:
    if selected_files:
        return get_source_files(src_dir, selected_files=selected_files)

    if translate_flagged and translate_stale:
        flagged = get_flagged_or_missing_source_files(
            src_dir, target_dir, flagged_order=flagged_order
        )
        stale = get_stale_source_files(src_dir, target_dir)
        unique = {path.name: path for path in flagged}
        for path in stale:
            unique[path.name] = path
        return [unique[name] for name in sorted(unique)]

    if translate_flagged:
        return get_flagged_or_missing_source_files(
            src_dir, target_dir, flagged_order=flagged_order
        )

    if translate_stale:
        return get_stale_source_files(src_dir, target_dir)

    return get_source_files(src_dir)


def parse_args():
    parser = argparse.ArgumentParser(
        description="Regenerate English blog posts from Korean source posts."
    )
    parser.add_argument(
        "--source-dir",
        default="_posts",
        help="Directory containing Korean source posts",
    )
    parser.add_argument(
        "--target-dir",
        default="_posts/en",
        help="Directory where English posts will be written",
    )
    parser.add_argument(
        "--overwrite",
        action="store_true",
        help="Overwrite existing English files",
    )
    parser.add_argument(
        "--clean",
        action="store_true",
        help="Delete existing translated Markdown files in the target directory before regeneration",
    )
    parser.add_argument(
        "--limit",
        type=int,
        default=None,
        help="Translate only the first N source posts after sorting",
    )
    parser.add_argument(
        "--files",
        nargs="*",
        default=None,
        help="Translate only the specified source Markdown files",
    )
    parser.add_argument(
        "--verify-existing",
        action="store_true",
        help="Verify existing English translations for likely truncation or structure loss",
    )
    parser.add_argument(
        "--continue-on-error",
        action="store_true",
        help="Continue translating remaining files even if one file fails",
    )
    parser.add_argument(
        "--print-flagged-files",
        action="store_true",
        help="When used with --verify-existing, print only flagged or missing filenames after the summary",
    )
    parser.add_argument(
        "--print-flagged-cost",
        action="store_true",
        help="When used with --verify-existing, print only flagged files with source char and chunk estimates",
    )
    parser.add_argument(
        "--translate-flagged",
        action="store_true",
        help="Translate only currently flagged or missing English posts",
    )
    parser.add_argument(
        "--translate-stale",
        action="store_true",
        help="Translate only English posts whose source hash no longer matches the Korean source",
    )
    parser.add_argument(
        "--flagged-order",
        choices=["cheapest", "largest", "name"],
        default="cheapest",
        help="Order used when translating flagged posts",
    )
    parser.add_argument(
        "--report-json",
        default=None,
        help="Write verification results to a JSON file",
    )
    parser.add_argument(
        "--print-stale-files",
        action="store_true",
        help="Print only stale translated filenames based on source hash mismatch",
    )
    return parser.parse_args()


def main():
    args = parse_args()

    src_dir = Path(args.source_dir)
    target_dir = Path(args.target_dir)

    if args.verify_existing:
        report = collect_translation_reports(
            src_dir, target_dir, selected_files=args.files
        )
        if args.report_json:
            write_report_json(args.report_json, report)
        if args.print_flagged_cost:
            flagged_reports = [item for item in report["reports"] if item["flags"]]
            flagged_reports.sort(
                key=lambda item: (item["estimated_chunks"], item["source_chars"], item["file"]),
            )
            for item in flagged_reports:
                print(
                    f"{item['file']}\tchars={item['source_chars']}\tchunks={item['estimated_chunks']}\tflags={','.join(item['flags'])}"
                )
            for name in report["missing_files"]:
                source_path = src_dir / name
                if source_path.exists():
                    source_text = source_path.read_text(encoding="utf-8")
                    _, source_body, _ = split_front_matter(source_text)
                    print(
                        f"{name}\tchars={len(source_body)}\tchunks={len(chunk_markdown(source_body))}\tflags=missing"
                    )
            raise SystemExit(1 if report["flagged_count"] or report["missing_count"] else 0)
        if args.print_flagged_files:
            for name in report["flagged_files"]:
                print(name)
            for name in report["missing_files"]:
                print(name)
            raise SystemExit(1 if report["flagged_count"] or report["missing_count"] else 0)
        raise SystemExit(
            verify_existing_translations(
                src_dir, target_dir, selected_files=args.files
            )
        )

    if args.print_stale_files:
        stale_files = get_stale_source_files(src_dir, target_dir)
        for path in stale_files:
            print(path.name)
        raise SystemExit(1 if stale_files else 0)

    if not API_KEY:
        raise EnvironmentError(
            "Missing OpenAI API key. Set OPENAI_API_KEY before running translate.py."
        )

    if args.clean:
        clean_target_dir(target_dir)
    else:
        target_dir.mkdir(parents=True, exist_ok=True)

    files = get_targeted_source_files(
        src_dir,
        target_dir,
        selected_files=args.files,
        translate_flagged=args.translate_flagged,
        translate_stale=args.translate_stale,
        flagged_order=args.flagged_order,
    )
    if args.limit is not None:
        files = files[: args.limit]

    translation_summary = translate_files(
        files,
        target_dir,
        overwrite=args.overwrite,
        continue_on_error=args.continue_on_error,
    )

    if args.report_json:
        report = {
            "translation": translation_summary,
            "verification": collect_translation_reports(
                src_dir, target_dir, selected_files=args.files
            ),
        }
        write_report_json(args.report_json, report)

    if translation_summary["failed_count"]:
        raise SystemExit(1)


if __name__ == "__main__":
    main()
