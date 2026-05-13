---
allowed-tools: Bash, Write, Read
description: 현재 세션 컨텍스트를 RELAY.md에 저장하고 Codex CLI로 핸드오프
---

현재 Claude Code 세션의 컨텍스트를 RELAY.md 파일에 저장한 다음 새 터미널 창에서 Codex CLI를 자동으로 시작해. 아래 단계를 순서대로 실행해.

## 1단계. 기존 RELAY.md 백업

`Bash` 툴로 다음을 실행해.

```bash
[ -f ./RELAY.md ] && mv ./RELAY.md ./RELAY.bak.md || true
```

## 2단계. RELAY.md 작성

`Write` 툴로 `./RELAY.md`를 생성해. 아래 형식을 그대로 사용하되, 각 섹션을 현재 대화 내용으로 채워. 반드시 한국어로 작성.

```
# RELAY — From Claude Code → Codex

## Timestamp
(현재 시각 ISO 8601 형식)

## Working Directory
(Bash 툴로 `pwd` 실행해서 결과 기재)

## Task Summary
(이번 세션에서 무엇을 하고 있었는지 1~3 문단으로 요약. 배경과 목표 포함.)

## Decisions
(이번 세션에서 내린 결정들을 불릿으로 나열. 각 결정에 짧은 이유 덧붙이기.)
- 결정 1: ...
- 결정 2: ...

## Files Changed
(수정하거나 생성한 파일 목록. 경로와 한줄 설명.)
- `경로/파일.ts` — 설명
- `경로/파일2.ts` — 설명

## Open Items
(아직 완료하지 못한 작업 체크박스)
- [ ] 할 일 1
- [ ] 할 일 2

## Hand-off Notes
(다음 CLI가 알아야 할 함정, 임시 상태, 주의사항, 미완 코드 등)

## Next Step
(새 세션이 바로 시작할 첫 번째 행동 한 문장)
```

## 3단계. 새 터미널에서 Codex 시작

`Bash` 툴로 다음을 실행해. 이 명령은 현재 세션과 독립된 새 터미널 창에서 codex를 자동으로 띄워.

```bash
INIT_PROMPT='@RELAY.md 파일을 읽고 핸드오프 노트를 따라 이전 세션의 작업을 이어서 진행해줘.'
CWD="$(pwd)"
CMD="cd \"$CWD\" && codex \"$INIT_PROMPT\"; exec bash"
if   command -v ghostty             >/dev/null 2>&1; then setsid ghostty             -e bash -c "$CMD" </dev/null >/dev/null 2>&1 &
elif command -v xdg-terminal-exec   >/dev/null 2>&1; then setsid xdg-terminal-exec  bash -c "$CMD" </dev/null >/dev/null 2>&1 &
elif command -v ptyxis              >/dev/null 2>&1; then setsid ptyxis --new-window -d "$CWD" -- bash -c "$CMD" </dev/null >/dev/null 2>&1 &
elif command -v x-terminal-emulator >/dev/null 2>&1; then setsid x-terminal-emulator -e bash -c "$CMD" </dev/null >/dev/null 2>&1 &
elif command -v xterm               >/dev/null 2>&1; then setsid xterm               -e bash -c "$CMD" </dev/null >/dev/null 2>&1 &
else echo "터미널 에뮬레이터를 찾을 수 없습니다. 수동으로 실행하세요: cd \"$CWD\" && codex \"$INIT_PROMPT\"" >&2; exit 1
fi
echo "spawn ok"
```

## 4단계. 완료 안내

다음 메시지를 사용자에게 출력해.

"RELAY.md 저장 완료. 새 터미널에서 Codex 세션이 시작됐어요. 이 세션은 계속 사용하거나 종료해도 돼요."
