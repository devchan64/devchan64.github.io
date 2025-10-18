#!/usr/bin/env python3
import os
import sys
import subprocess
from pathlib import Path
from shlex import quote

# ==== Utilities ================================================================
def run(cmd: list[str]) -> str:
    out = subprocess.check_output(cmd, text=True)
    return out.strip()

def call(cmd: list[str]) -> None:
    subprocess.check_call(cmd)

def ensure_cmd_exists(cmd: str) -> None:
    if subprocess.call(["which", cmd], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL) != 0:
        raise RuntimeError(f"'{cmd}' 명령을 찾을 수 없습니다. 설치 후 다시 시도하세요.")

def gsettings_set(schema: str, key: str, value: str) -> None:
    call(["gsettings", "set", schema, key, value])

def gsettings_get(schema: str, key: str) -> str:
    return run(["gsettings", "get", schema, key])

# ==== Preconditions ============================================================
if sys.platform != "linux":
    raise RuntimeError("이 스크립트는 Linux GNOME 환경에서만 동작합니다.")

for c in ["gsettings", "dconf", "bash", "git"]:
    ensure_cmd_exists(c)

# ==== 0) 패키지 설치 ==========================================================
print("[INFO] 패키지 설치 (JetBrains Mono, Fira Code, gnome-themes-extra)")
call(["bash", "-lc", "sudo apt update -y"])
call(["bash", "-lc", "sudo apt install -y fonts-firacode fonts-jetbrains-mono gnome-themes-extra"])

# ==== 1) Nord 팔레트 정의 =====================================================
nord = {
    "nord0":  "#2E3440",
    "nord1":  "#3B4252",
    "nord2":  "#434C5E",
    "nord3":  "#4C566A",
    "nord4":  "#D8DEE9",
    "nord5":  "#E5E9F0",
    "nord6":  "#ECEFF4",
    "nord7":  "#8FBCBB",
    "nord8":  "#88C0D0",
    "nord9":  "#81A1C1",
    "nord10": "#5E81AC",
    "nord11": "#BF616A",
    "nord12": "#D08770",
    "nord13": "#EBCB8B",
    "nord14": "#A3BE8C",
    "nord15": "#B48EAD",
}
palette16 = [
    nord["nord1"], nord["nord11"], nord["nord14"], nord["nord13"], nord["nord9"], nord["nord15"],
    nord["nord8"], nord["nord5"], nord["nord3"], nord["nord11"], nord["nord14"], nord["nord13"],
    nord["nord9"], nord["nord15"], nord["nord7"], nord["nord6"]
]
palette_gsettings = "[" + ", ".join(f"'{c}'" for c in palette16) + "]"
bg = nord["nord0"]
fg = nord["nord4"]
bold = nord["nord6"]
cursor_fg = nord["nord0"]
cursor_bg = nord["nord4"]

# ==== 2) GNOME 기본 UI 테마 + 폰트 ===========================================
print("[INFO] GNOME 다크모드 + 폰트 설정")
gsettings_set("org.gnome.desktop.interface", "color-scheme", "'prefer-dark'")
gsettings_set("org.gnome.desktop.interface", "monospace-font-name", "'JetBrains Mono 12'")

# ==== 3) Dock 하단-가운데 ======================================
print("[INFO] Dock 하단-가운데 정렬 (panel-mode 키 없이 구성)")
gsettings_set("org.gnome.shell.extensions.dash-to-dock", "dock-position", "'BOTTOM'")
# 전체 폭으로 늘리는 동작을 끄면 아이콘이 가운데로 배치됨
gsettings_set("org.gnome.shell.extensions.dash-to-dock", "extend-height", "false")



# ==== 4) 배경화면 (background.jpg) ===========================================
print("[INFO] background.jpg 파일 설정")
cwd = Path.cwd()
src = cwd / "background.jpg"
if not src.exists():
    raise FileNotFoundError(f"배경화면 파일을 찾을 수 없습니다: {src}")

bg_dir = Path.home() / ".local" / "share" / "backgrounds"
bg_dir.mkdir(parents=True, exist_ok=True)

dst = bg_dir / "background.jpg"
dst.write_bytes(src.read_bytes())

uri = f"file://{dst}"
gsettings_set("org.gnome.desktop.background", "picture-uri", f"'{uri}'")
gsettings_set("org.gnome.desktop.background", "picture-uri-dark", f"'{uri}'")
gsettings_set("org.gnome.desktop.background", "picture-options", "'zoom'")

# ==== 5) GNOME Terminal Nord 테마 적용 =======================================
print("[INFO] GNOME Terminal Nord 팔레트 적용")

default_uuid = gsettings_get("org.gnome.Terminal.ProfilesList", "default").strip().strip("'")
profiles_list_raw = gsettings_get("org.gnome.Terminal.ProfilesList", "list").strip()

if not default_uuid or default_uuid not in profiles_list_raw:
    raise RuntimeError("GNOME Terminal 기본 프로필 UUID를 찾을 수 없습니다. 터미널을 한 번 실행한 후 다시 시도하세요.")

profile_path = f"/org/gnome/terminal/legacy/profiles:/:{default_uuid}/"
schema_with_path = f"org.gnome.Terminal.Legacy.Profile:{profile_path}"

def term_set(key: str, value: str) -> None:
    call(["gsettings", "set", schema_with_path, key, value])

term_set("use-theme-colors", "false")
term_set("palette", palette_gsettings)
term_set("background-color", f"'{bg}'")
term_set("foreground-color", f"'{fg}'")
term_set("bold-color-same-as-fg", "false")
term_set("bold-color", f"'{bold}'")
term_set("cursor-colors-set", "true")
term_set("cursor-foreground-color", f"'{cursor_fg}'")
term_set("cursor-background-color", f"'{cursor_bg}'")
term_set("use-transparent-background", "false")
term_set("visible-name", "'Nord'")

# ==== Done ====================================================================
print("\n[OK] Nord 테마, Dock, 배경화면(background.jpg), 폰트, 터미널 컬러 설정 완료!")
print("GNOME Shell 재시작(Alt+F2 → r → Enter) 또는 재로그인을 권장합니다.")
