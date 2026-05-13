#!/usr/bin/env bash
# Codex → Claude Code 핸드오프. 새 터미널 창에서 claude를 첫 프롬프트와 함께 실행 (수동 호출/디버깅용)
# WARNING: 디버그용 사본. 정식 터미널 감지 체인은 plugins/relay-codex/commands/relay.md (3단계) 에 있음.
#          터미널 에뮬레이터를 추가/변경할 때는 두 곳을 모두 수정할 것.
set -euo pipefail

INIT_PROMPT='@RELAY.md 파일을 읽고 핸드오프 노트를 따라 이전 세션의 작업을 이어서 진행해줘.'
CWD="$(pwd)"
CMD="cd \"$CWD\" && exec claude \"$INIT_PROMPT\""

if   command -v ghostty             >/dev/null 2>&1; then setsid ghostty             -e bash -c "$CMD" </dev/null >/dev/null 2>&1 &
elif command -v xdg-terminal-exec   >/dev/null 2>&1; then setsid xdg-terminal-exec  bash -c "$CMD" </dev/null >/dev/null 2>&1 &
elif command -v ptyxis              >/dev/null 2>&1; then setsid ptyxis --new-window -d "$CWD" -- bash -c "$CMD" </dev/null >/dev/null 2>&1 &
elif command -v x-terminal-emulator >/dev/null 2>&1; then setsid x-terminal-emulator -e bash -c "$CMD" </dev/null >/dev/null 2>&1 &
elif command -v xterm               >/dev/null 2>&1; then setsid xterm               -e bash -c "$CMD" </dev/null >/dev/null 2>&1 &
else
  echo "터미널 에뮬레이터를 찾을 수 없습니다. 수동으로 실행하세요." >&2
  echo "  cd \"$CWD\" && claude \"$INIT_PROMPT\"" >&2
  exit 1
fi

echo "Claude Code 세션 시작 중..."
