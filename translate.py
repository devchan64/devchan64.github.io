import os
import openai
import subprocess
from pathlib import Path
import re

openai.api_key = os.getenv("OPENAPIKEY")

def split_front_matter(text):
    match = re.match(r'^(---\n.*?\n---\n)(.*)', text, re.DOTALL)
    return match.groups() if match else ("", text)

def translate_text(text):
    prompt = (
        "Translate the following Markdown from Korean to fluent English.\n"
        "Preserve all Markdown formatting such as headings, bold, lists, and code blocks.\n"
        "Do not translate code or filenames.\n\n"
        f"{text}"
    )
    response = openai.ChatCompletion.create(
        model="gpt-4-turbo",
        messages=[{"role": "user", "content": prompt}],
        temperature=0.7
    )
    return response.choices[0].message.content.strip()

def get_modified_md_files():
    result = subprocess.run(
        ["git", "diff", "--name-only", "HEAD^", "HEAD"],
        capture_output=True, text=True
    )
    return [line for line in result.stdout.splitlines() if line.startswith("_posts/") and line.endswith(".md")]

def main():
    files = get_modified_md_files()
    for filepath in files:
        path = Path(filepath)
        output_path = path.parent / "en" / path.name

        # 이미 번역된 파일이 존재하면 건너뜀
        if output_path.exists():
            print(f"[SKIP] Already translated: {output_path}")
            continue

        # 번역 수행
        with open(path, "r", encoding="utf-8") as f:
            content = f.read()

        front, body = split_front_matter(content)
        translated_body = translate_text(body)

        output_path.parent.mkdir(parents=True, exist_ok=True)
        with open(output_path, "w", encoding="utf-8") as f:
            f.write(front + translated_body)

        print(f"[OK] Translated: {output_path}")


if __name__ == "__main__":
    main()
