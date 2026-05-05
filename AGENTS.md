# AGENTS.md

Instructions for AI coding agents (Claude Code, Codex, Cursor, Copilot).

## Setup

```bash
uv sync
```

## Commands

- Run tests: `uv run pytest`
- Lint + auto-fix: `uv run ruff check --fix`
- Format: `uv run ruff format`
- Type-check: `uv run ty check`

Run all four before submitting a PR. CI runs the same commands.

## Conventions

- Python 3.12+. Use modern syntax: `match`, PEP 695 generics, `|` unions.
- Type-hint all public functions. Internal helpers may skip if obvious.
- Docstrings on public APIs only. Style: short imperative summary line.
- Tests live in `tests/`, mirror `src/` layout, use plain `assert`.
- No new top-level dependencies without discussion. Dev deps go in
  `dependency-groups.dev`.

## Don't

- Don't add `# type: ignore` without a comment explaining why.
- Don't commit without `ruff check`, `ruff format`, and `ty check` passing.
- Don't introduce sync I/O in async paths or vice versa.
