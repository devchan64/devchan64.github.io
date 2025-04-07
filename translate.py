import os
from openai import OpenAI
from pathlib import Path
import re
import yaml
from datetime import datetime

client = OpenAI(api_key=os.getenv("OPENAPIKEY"))

def split_front_matter(text):
    match = re.match(r'^(---\n.*?\n---\n)(.*)', text, re.DOTALL)
    if not match:
        return "", text, {}
    
    front_raw, body = match.groups()
    front_dict = yaml.safe_load(front_raw.strip("---\n"))
    return front_raw, body, front_dict

def reconstruct_front_matter(front_dict):
    return "---\n" + yaml.dump(front_dict, allow_unicode=True) + "---\n"

def translate_text(text):
    prompt = (
        "Translate the following text from Korean to fluent English.\n"
        "Preserve all Markdown formatting such as headings, bold, lists, and code blocks.\n"
        "Do not translate code or filenames.\n\n"
        f"{text}"
    )

    response = client.chat.completions.create(
        model="gpt-4-turbo",
        messages=[{"role": "user", "content": prompt}],
        temperature=0.7
    )

    return response.choices[0].message.content.strip()

def generate_permalink(post: Path, front_dict: dict) -> str:
    # 파일명 기반: 2024-04-01-something.md → date, slug 추출
    filename = post.stem  # '2024-04-01-title'
    date_part, *slug_parts = filename.split('-')
    if len(slug_parts) < 2:
        raise ValueError(f"Invalid post filename format: {post.name}")

    year, month, day = filename[:10].split('-')
    slug = '-'.join(slug_parts)

    permalink = f"/en/{year}/{month}/{day}/{slug}.html"
    return permalink


def get_untranslated_md_files():
    src_dir = Path("_posts")
    en_dir = src_dir / "en"
    en_dir.mkdir(exist_ok=True)

    untranslated_files = []

    for md_file in src_dir.glob("*.md"):
        translated_file = en_dir / md_file.name
        if not translated_file.exists():
            untranslated_files.append(md_file)

    return untranslated_files

def main():
    files = get_untranslated_md_files()
    for path in files:
        output_path = path.parent / "en" / path.name

        with open(path, "r", encoding="utf-8") as f:
            content = f.read()

        front_raw, body, front_dict = split_front_matter(content)

        # 🔁 title 번역
        if "title" in front_dict:
            front_dict["title"] = translate_text(front_dict["title"])

        # 🔁 tags 번역 (리스트)
        if "tags" in front_dict and isinstance(front_dict["tags"], list):
            translated_tags = [translate_text(tag) for tag in front_dict["tags"]]
            front_dict["tags"] = translated_tags

        # permalink 자동 삽입
        front_dict["permalink"] = generate_permalink(path, front_dict)


        # 🔁 본문 번역
        translated_body = translate_text(body)

        notice = "> `gpt-4-turbo` has translated this article into English.\n\n"
        translated_body = notice + translated_body

        new_front = reconstruct_front_matter(front_dict)

        output_path.parent.mkdir(parents=True, exist_ok=True)
        with open(output_path, "w", encoding="utf-8") as f:
            f.write(new_front + translated_body)

        print(f"[OK] Translated: {output_path}")
        break  # 🔄 한 번만 테스트 시 break 유지

if __name__ == "__main__":
    main()
