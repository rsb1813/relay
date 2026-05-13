# relay

Claude Code ↔ Codex CLI를 `/relay` 슬래시 명령 하나로 오간다.

호출하면 현재 세션의 작업 내용·결정·변경 파일·TODO를 cwd의 `RELAY.md`에 요약 저장하고, 새 터미널 창에서 반대편 CLI가 자동으로 시작된다. 새 세션은 `@RELAY.md 읽고 이어서 작업해줘` 프롬프트를 첫 메시지로 받아 컨텍스트를 이어간다.

## 설치 — Claude Code

```bash
claude plugins marketplace add rsb1813/relay
claude plugins install relay-claude@relay
```

Claude Code 재시작 후 `/relay`를 슬래시 메뉴에서 사용할 수 있다.

**일회성 테스트 (재시작 없이)**

```bash
git clone https://github.com/rsb1813/relay ~/relay
claude --plugin-dir ~/relay/plugins/relay-claude
```

세션이 끝나면 비활성화된다.

## 설치 — Codex

```bash
codex plugin marketplace add rsb1813/relay
```

등록 즉시 `relay-codex` 플러그인이 활성화된다.

## 사용법

어느 CLI에서든 `/relay`를 입력하면 된다.

1. LLM이 현재 작업 컨텍스트를 cwd의 `RELAY.md`에 한국어로 저장한다.
2. 새 터미널 창이 열리고 반대편 CLI가 자동으로 시작된다.
3. 새 세션의 첫 메시지로 `@RELAY.md 읽고 이어서 작업해줘`가 자동으로 들어간다.

## RELAY.md 형식

저장되는 파일은 아래 섹션을 포함한다.

| 섹션 | 내용 |
|---|---|
| `From → To` | 어느 CLI에서 어느 CLI로 |
| `Timestamp` | ISO 8601 |
| `Working Directory` | pwd 결과 |
| `Task Summary` | 작업 배경과 목표 |
| `Decisions` | 이번 세션 결정 + 이유 |
| `Files Changed` | 수정/생성 파일 목록 |
| `Open Items` | 남은 TODO 체크박스 |
| `Hand-off Notes` | 다음 CLI가 알아야 할 주의사항 |
| `Next Step` | 새 세션이 시작할 첫 행동 |

**주의.** `RELAY.md`는 `/relay`로 시작한 세션에만 자동으로 전달된다. 그냥 `claude` / `codex`를 실행하면 `RELAY.md`가 cwd에 있어도 무시된다.

**주의.** `/relay`를 같은 cwd에서 여러 번 호출하면 직전 `RELAY.md`는 `RELAY.bak.md`로 백업된다. 최근 하나만 보존된다.

## 지원 터미널

새 창 스폰 시 아래 순서로 찾는다.

`ghostty` → `xdg-terminal-exec` → `ptyxis` → `x-terminal-emulator` → `xterm`

없으면 수동 실행 명령을 stderr에 출력한다.

## 트러블슈팅

**`/relay`가 슬래시 메뉴에 안 보인다**

- Claude Code. `claude plugins list`로 `relay-claude`가 있는지 확인. 없으면 다시 설치한다.
  ```bash
  claude plugins marketplace add rsb1813/relay
  claude plugins install relay-claude@relay
  ```
- Codex. `codex plugin marketplace add rsb1813/relay`를 다시 실행한다.

**새 터미널이 뜨지 않는다**

저장소를 클론한 위치에서 spawn 스크립트를 수동으로 실행해서 오류를 확인한다.

```bash
# Claude → Codex 방향
bash ~/relay/plugins/relay-claude/scripts/spawn-relay.sh

# Codex → Claude 방향
bash ~/relay/plugins/relay-codex/scripts/spawn-relay.sh
```

**RELAY.md가 이전 내용과 섞였다**

같은 cwd에서 `/relay`를 두 번 호출하면 두 번째 것이 첫 번째 것을 `RELAY.bak.md`로 대체한다. 히스토리가 필요하면 RELAY.md를 직접 다른 이름으로 복사해두자.

## 제거

```bash
# Claude Code
claude plugins uninstall relay-claude
claude plugins marketplace remove relay

# Codex
codex plugin marketplace remove rsb1813/relay
```
