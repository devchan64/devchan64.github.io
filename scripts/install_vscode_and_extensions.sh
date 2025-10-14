#!/usr/bin/env bash
set -euo pipefail

echo "[INFO] VS Code + 확장 자동설치 시작"

# --- 요구 패키지 ---
echo "[INFO] 기본 도구 설치(curl, gpg, jq)"
sudo apt update -y
sudo apt install -y curl gpg jq ca-certificates apt-transport-https

# --- VS Code 저장소 추가 및 설치 ---
if ! command -v code >/dev/null 2>&1; then
	echo "[INFO] VS Code 저장소 등록 및 설치"
	tmpkey="$(mktemp)"
	curl -fsSL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor >"$tmpkey"
	sudo install -D -o root -g root -m 644 "$tmpkey" /etc/apt/keyrings/packages.microsoft.gpg
	rm -f "$tmpkey"
	echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" |
		sudo tee /etc/apt/sources.list.d/vscode.list >/dev/null
	sudo apt update -y
	sudo apt install -y code
else
	echo "[INFO] VS Code 이미 설치됨 - 버전: $(code --version | head -n1)"
fi

# --- code CLI 점검 ---
if ! command -v code >/dev/null 2>&1; then
	echo "[ERROR] code 명령을 찾을 수 없습니다(설치 실패)"
	exit 1
fi

# --- 포매터/린터 외부 도구(쉘 전용) ---
# foxundermoon.shell-format이 외부 shfmt를 활용하므로 같이 설치(가능한 경우)
echo "[INFO] shfmt / shellcheck 설치"
sudo apt install -y shfmt shellcheck || {
	echo "[WARN] shfmt/shellcheck 설치 실패(레포/플랫폼 차이). VSCode 확장만으로 진행합니다."
}

# --- 설치할 확장 정의 ---
# Python3, Black, NodeJS(ESLint/Prettier), Bash(shell-format), GitHub 확장
EXTENSIONS=(
	"ms-python.python"
	"ms-python.black-formatter"
	"ms-toolsai.jupyter"
	"dbaeumer.vscode-eslint"            # NodeJS/TS 린팅 + fixAll
	"esbenp.prettier-vscode"            # NodeJS/TS/웹 포매터
	"foxundermoon.shell-format"         # Bash/Shell 포매터(shfmt 기반)
	"GitHub.vscode-pull-request-github" # GitHub PR/이슈
)

echo "[INFO] 확장 설치: ${EXTENSIONS[*]}"
for ext in "${EXTENSIONS[@]}"; do
	if code --list-extensions | grep -qi "^${ext}$"; then
		echo "[INFO] 이미 설치됨: $ext"
	else
		echo "[INFO] 설치 중: $ext"
		code --install-extension "$ext" --force
	fi
done

# --- 사용자 설정 (settings.json) 갱신: 저장 시 포맷 + 언어별 기본 포매터 ---
SETTINGS_DIR="$HOME/.config/Code/User"
SETTINGS_FILE="$SETTINGS_DIR/settings.json"
mkdir -p "$SETTINGS_DIR"

if [[ -f "$SETTINGS_FILE" ]]; then
	current="$(cat "$SETTINGS_FILE")"
else
	current="{}"
fi

# jq 병합: 언어별 defaultFormatter 지정
# - Python: Black
# - JS/TS/React/JSON/Markdown: Prettier
# - Shell: foxundermoon.shell-format (shfmt 사용)
# - 저장 시 formatOnSave, ESLint fixAll(On Save는 explicit로)
merged="$(jq -c '
  . + {
    "editor.formatOnSave": true,
    "editor.codeActionsOnSave": {
      "source.fixAll.eslint": "explicit",
      "source.organizeImports": "explicit"
    },
    "[python]": {
      "editor.defaultFormatter": "ms-python.black-formatter"
    },
    "python.formatting.provider": "none",
    "python.analysis.typeCheckingMode": "basic",
    "black-formatter.path": ["black"],
    "python.terminal.activateEnvironment": true,

    "[javascript]": {
      "editor.defaultFormatter": "esbenp.prettier-vscode"
    },
    "[javascriptreact]": {
      "editor.defaultFormatter": "esbenp.prettier-vscode"
    },
    "[typescript]": {
      "editor.defaultFormatter": "esbenp.prettier-vscode"
    },
    "[typescriptreact]": {
      "editor.defaultFormatter": "esbenp.prettier-vscode"
    },
    "[json]": {
      "editor.defaultFormatter": "esbenp.prettier-vscode"
    },
    "[jsonc]": {
      "editor.defaultFormatter": "esbenp.prettier-vscode"
    },
    "[markdown]": {
      "editor.defaultFormatter": "esbenp.prettier-vscode"
    },

    "[shellscript]": {
      "editor.defaultFormatter": "foxundermoon.shell-format"
    },
    "shellformat.path": "shfmt",
    "shellformat.flag": "-i 2 -bn -ci"
  }
' <<<"$current")"

echo "$merged" >"$SETTINGS_FILE"

echo "----------------------------------------"
echo "[DONE] VS Code 설치 및 확장/설정 완료"
echo "확인:"
echo "  code --list-extensions | egrep \"ms-python.python|ms-python.black-formatter|dbaeumer.vscode-eslint|esbenp.prettier-vscode|foxundermoon.shell-format|GitHub.vscode-pull-request-github\""
echo "  cat $SETTINGS_FILE"
echo "----------------------------------------"
