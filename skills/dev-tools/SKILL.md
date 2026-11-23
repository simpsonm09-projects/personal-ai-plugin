---
name: dev-tools
description: Use when configuring or troubleshooting the personal developer tools in this workspace, such as Zed, Noctty, Sublime Text, OpenCode, T3 Code, or Claude Code. Says where each tool's settings live and how to apply them.
---

# Personal dev tools

Machine setup lives in the `sakuragaoka-homelab` machine repositories. This skill owns where each tool keeps its settings and how to apply a change.

| Tool | Role | Settings and apply |
| --- | --- | --- |
| Zed | IDE | `~/.config/zed/settings.json`, edited by hand |
| Noctty | Terminal | Set in the app's settings; no repository file applies it |
| Sublime Text | Text editor | Linux app with no portable settings yet |
| OpenCode CLI | AI CLI; T3 Code also starts an OpenCode server | The workspace config is authoritative; the global config must not set a model |
| T3 Code | Desktop GUI for coding agents (Claude Code and OpenCode providers) | Set in the app's Settings screen, not in a file the repository applies. Installed with the Linux package manager |
| Claude Code | AI CLI (Claude provider for T3 Code) | No settings file in the repository. Installed separately as the npm global `@anthropic-ai/claude-code`. The Claude plugin composition belongs to `maxstack` |

## Notes

- After a plugin, skill, or MCP change, use "Restart agent session" in T3 Code.
- Secrets do not load into a shell. Run a command that needs them as `with-secrets --require <names> <command>`, naming the keys it needs. Remove a workspace `.envrc` that imports secrets; `with-secrets` warns when one is present. See the `agent-vault` skill.
