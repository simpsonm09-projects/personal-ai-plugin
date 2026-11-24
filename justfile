# Task runner for humans and agents. `just --list` shows every
# recipe. Keep each recipe a thin call to a portable tool or a script under
# scripts/. See https://github.com/simpsonm09-projects/repo-standard/blob/main/docs/task-runner.md

# List the recipes.
default:
    @just --list

# Install the pinned tools.
install:
    mise install

# Install the dependencies from the lockfile.
deps:
    mise exec -- bun install --frozen-lockfile

# Format JavaScript and TypeScript with Bun.
fmt *files:
    mise exec -- node scripts/fmt.mjs {{files}}

# Check JavaScript and TypeScript formatting with Bun.
fmt-check:
    mise exec -- bun fmt --check index.ts tests scripts

# Type check the plugin and the repository scripts with Bun.
typecheck:
    mise exec -- bun check

# Lint JavaScript and TypeScript, through Bun with an oxlint fallback.
lint *files:
    mise exec -- bun scripts/lint.ts

# Run the AI-slop gate.
aislop:
    npx --yes aislop@0.16.1 ci

# Run the test suite.
test:
    mise exec -- bun test

# Run the tests and write an lcov report to coverage/lcov.info.
coverage:
    mise exec -- bun install --frozen-lockfile
    mise exec -- bun test --coverage --coverage-reporter=lcov --coverage-dir=coverage

# Validate the layer contract on its own.
validate:
    mise exec -- bun scripts/validate-layer.mjs

# Everything CI requires.
check: fmt-check lint typecheck test

# Historical alias for `check`, kept for the support template.
verify: check

# Install the shared Lefthook hooks and assert the merged jobs (C7.8).
hooks:
    mise exec -- node scripts/hooks.ts

# Install the discli Discord CLI and run discli doctor.
setup-discli:
    mise exec -- bash scripts/setup-discli.sh

# Check the .agents/skills tree; this repository has none (C7.10).
agent-files:
    @echo agent-files: no .agents tree

# Staged secret scan (C7.10).
secrets-staged:
    mise exec -- gitleaks git --staged --redact --no-banner

# Reject env files, private keys, kubeconfigs and files over 5 MB (C7.10).
forbidden-files *files:
    mise exec -- node scripts/forbidden-files.ts {{files}}

# actionlint and zizmor over the given workflows, or every workflow (C7.10).
workflows *files:
    {{ if files == "" { "mise exec -- actionlint" } else { "mise exec -- actionlint -- " + files } }}
    {{ if files == "" { "mise exec -- zizmor --quiet .github/workflows" } else { "mise exec -- zizmor --quiet " + files } }}

# shellcheck over the given scripts; nothing to do when none are given (C7.10).
shellcheck *files:
    {{ if files == "" { "echo shellcheck: no files to check" } else { "mise exec -- shellcheck -- " + files } }}

# Advisory Conventional Commit check (C2.4); never fails the commit (C7.10).
commit-msg file:
    mise exec -- node scripts/commit-msg.ts {{quote(file)}}

# Read the pushed refs from stdin, refuse main, and scan the range (C7.10).
hook-pre-push:
    mise exec -- node scripts/git-hook.ts pre-push

# Fast pre-push subset, under 30 seconds (C7.10). It runs the same
# recipes the required pull-request checks run, so CI confirms what
# the hook already caught (C5.7).
pre-push-check:
    just fmt-check
    just lint
    just typecheck
    just test

# Refresh locked dependencies when a manifest changed (C7.10).
deps-refresh *files:
    {{ if files == "" { "mise exec -- node scripts/deps-refresh.ts mise.toml bun.lock" } else { "mise exec -- node scripts/deps-refresh.ts " + files } }}

# Owner hook: fail when this checkout cannot sign commits (C2.7).
signing-check:
    mise exec -- node scripts/signing-check.mjs

# Prune remote-tracking refs and delete local branches merged into main.
prune:
    mise exec -- bun scripts/prune.mjs
