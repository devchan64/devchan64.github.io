import os
from openai import OpenAI
from pathlib import Path
import re

client = OpenAI(api_key=os.getenv("OPENAPIKEY"))

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

    response = client.chat.completions.create(
        model="gpt-4-turbo",
        messages=[{"role": "user", "content": prompt}],
        temperature=0.7
    )

    return response.choices[0].message.content.strip()

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
    files = get_untranslated_md_files()  # ✅ 변경됨
    for path in files:
        output_path = path.parent / "en" / path.name

        with open(path, "r", encoding="utf-8") as f:
            content = f.read()

        front, body = split_front_matter(content)
        translated_body = translate_text(body)

        output_path.parent.mkdir(parents=True, exist_ok=True)
        with open(output_path, "w", encoding="utf-8") as f:
            f.write(front + translated_body)

        print(f"[OK] Translated: {output_path}")
        break


if __name__ == "__main__":
    main()
