# Cross-platform task runner for humans and agents. `just --list` shows every
# recipe. Keep each recipe a thin call to a portable tool or a script under
# scripts/. See https://github.com/simpsonm09-projects/repo-standard/blob/main/docs/task-runner.md
set windows-shell := ["powershell.exe", "-NoLogo", "-NoProfile", "-Command"]

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
fmt:
    mise exec -- bun fmt index.ts tests scripts

# Check JavaScript and TypeScript formatting with Bun.
fmt-check:
    mise exec -- bun fmt --check index.ts tests scripts

# Type check the plugin and the repository scripts with Bun.
typecheck:
    mise exec -- bun check

# Lint JavaScript and TypeScript, through Bun with an oxlint fallback.
lint:
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

# Install the guarded git hook.
hooks:
    git config --local core.hooksPath .githooks

# Install the discli Discord CLI and run discli doctor.
setup-discli:
    {{ if os_family() == "windows" { "pwsh -File scripts/setup-discli.ps1" } else { "bash scripts/setup-discli.sh" } }}

# Prune remote-tracking refs and delete local branches merged into main.
prune:
    mise exec -- bun scripts/prune.mjs
