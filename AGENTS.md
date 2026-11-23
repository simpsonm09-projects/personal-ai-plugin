# personal-ai-plugin working agreements

The personal plugin layer for `simpsonm09`. It serves OpenCode and Claude Code from one `skills/` folder.

## Ground rules

- The layer contributes no MCP server. Reach a personal service through its CLI. The org `service-integrations` registry names the general owner; this layer holds the personal concrete.
- Keep `layer.json`, `package.json`, and `opencode.fragment.jsonc` in sync. The contract test checks them.
- Values follow the four-tier store model. A committed file records only a variable name and the general rule, never a value. The gitignored `settings/.env` holds the Infisical machine identity (secret-zero) and a small offline fallback. Infisical `/secrets` holds credentials, and Infisical `/pii` holds PII and person or machine config. Online `with-secrets` reads only the store; the `.env` fallback is used only with `--offline`.
- Reach a brokered service, Discord or Postman, through a wrapper. The agent runs `with-vault --role agent <tool>` and the human runs `with-secrets <tool>` or `with-vault --role human <tool>`. A service token never goes into the environment or a config file on the agent path. The `agent-vault` skill owns the identities, the bundles, and the proxy.
- No personal secret or credential is committed.

## Commands

- `just install`, `just deps`, `just fmt-check`, `just lint`, `just typecheck`, `just test`, `just check`.
- `just setup-discli` installs the `discli` Discord CLI once per machine.

## Repo facts

- Language and toolchain: TypeScript and `@opencode/plugin`. Bun 1.4.5 formats, lints, type checks and runs the tests; the lockfile is `bun.lock`.
- `maxstack` composes this layer last, so it overrides the org layer on a same-key conflict.
- Skills: `integrations-personal`, `dev-tools`, `discord`, `agent-vault`.
- The README covers the contents, the layering, and the layer contract.
- Hooks: `just hooks` installs the shared Lefthook jobs from `simpsonm09-projects/.github` at the `hooks-v2` tag; `lefthook-local.yml` is git-ignored. Never skip a hook: no `LEFTHOOK=0`, no `--no-verify`, and never create `lefthook-local.yml` (C7.11). The ruleset is the real gate.

## Skills

The plugin registers the skills under `skills/`.
