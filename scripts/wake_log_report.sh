#!/bin/bash

echo "📅 최근 7일 출근 기록"
echo "-------------------------"

# set -x

for i in {0..6}; do
  TARGET_DATE=$(date -v -${i}d "+%Y-%m-%d")
  EVENT_LINE=$(pmset -g log \
    | awk -v date="$TARGET_DATE" '
      $0 ~ date && $2 >= "07:00:00" && $2 <= "19:00:00"
    ' \
    | grep -B 10 -A 30 "Display is turned on"\
    | grep -e "powerd process is started " \
    -e "Created UserIsActive \"Loginwindow User Activity\"" \
    | head -n 1)
  EVENT_LINE+=$(pmset -g log \
    | grep "$TARGET_DATE" \
    | grep -E "powerd process is started" \
    | head -n 1)

  if [ -n "$EVENT_LINE" ]; then
    TIME=$(echo "$EVENT_LINE" | awk '{print $1, $2}')
    echo "🟢 $TARGET_DATE 출근: $TIME"
  else
    echo "⚪️ $TARGET_DATE 출근 기록 없음"
  fi
done
