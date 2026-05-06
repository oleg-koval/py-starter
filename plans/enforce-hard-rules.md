# Plan: Enforce Hard Rules — py-starter

## Context

`py-starter` uses `uv` for dependency management, `ruff` for lint + format, `ty` for type
checking, and `pytest` with coverage. CI runs all four checks. What's missing is **local
enforcement** — no pre-commit hooks. The 300-line file cap is also not enforced: ruff's
`line-length` controls line width (currently 100), not lines-per-file.

Source: [oleg-koval/RULES.md §2](https://github.com/oleg-koval/starters/blob/main/RULES.md)

---

## Gaps

| Rule | Current state | Gap |
|------|--------------|-----|
| §2.2 File length 300-line cap | Not enforced (ruff `line-length` ≠ file length) | Add custom pre-commit file-length hook |
| §2.4 Pre-commit hooks | Not configured (CI-only) | Add `.pre-commit-config.yaml` |
| §2.3 E2E > unit | Only unit tests, no guidance | Add note to AGENTS.md + test example |

---

## Changes

### 1. Create `.pre-commit-config.yaml`

Uses the `pre-commit` framework. Wraps existing `uv run` commands so no new tools are needed
beyond `pre-commit` itself.

```yaml
default_language_version:
  python: python3.12

repos:
  - repo: local
    hooks:
      - id: ruff-lint
        name: ruff lint
        language: system
        entry: uv run ruff check --fix
        types: [python]
        pass_filenames: true

      - id: ruff-format
        name: ruff format
        language: system
        entry: uv run ruff format
        types: [python]
        pass_filenames: true

      - id: ty-check
        name: ty type check
        language: system
        entry: uv run ty check
        pass_filenames: false

      - id: pytest
        name: pytest
        language: system
        entry: uv run pytest --no-header -q
        pass_filenames: false

      - id: file-length-check
        name: file length ≤ 300 lines
        language: system
        entry: bash -c '
          failed=0
          for f in "$@"; do
            lines=$(wc -l < "$f")
            if [ "$lines" -gt 300 ]; then
              echo "ERROR: $f has $lines lines (max 300)"
              failed=1
            fi
          done
          exit $failed
        '
        types: [python]
        pass_filenames: true
```

> `ruff-lint` uses `--fix` so auto-fixable issues are corrected before the commit rather than
> blocking it. Non-auto-fixable issues still fail. `ruff-format` runs after lint to avoid
> ordering conflicts.

### 2. `pyproject.toml` — add ruff complexity rules

The `tool.ruff.lint` `select` block already includes `E`, `W`, `F`, `B`. Add complexity rules
that help enforce KISS principle (complement the 300-line cap):

```toml
[tool.ruff.lint]
select = [
  "E", "W",   # pycodestyle
  "F",        # pyflakes
  "I",        # isort
  "B",        # bugbear
  "UP",       # pyupgrade
  "N",        # pep8-naming
  "SIM",      # simplify
  "RUF",      # ruff-specific
  "C90",      # mccabe complexity
  "PLR",      # pylint refactor (includes too-many-statements, too-many-branches)
]

[tool.ruff.lint.mccabe]
max-complexity = 10

[tool.ruff.lint.pylint]
max-statements = 50
max-branches = 12
```

> `PLR0915` (too-many-statements) and `PLR0912` (too-many-branches) enforce function-level
> complexity limits that pair well with the file-length cap. Together they prevent "300 lines
> of spaghetti in one function".

### 3. `pyproject.toml` — add pre-commit to dev dependencies

```toml
[dependency-groups]
dev = [
  "pytest>=8.3",
  "pytest-cov>=5.0",
  "ruff>=0.7",
  "ty>=0.0.1a1",
  "pre-commit>=3.8",
]
```

### 4. Add `Makefile` (or update if it exists) with a `hooks` target

Create `Makefile` at repo root:

```makefile
.PHONY: lint format typecheck test hooks

lint:
	uv run ruff check --fix

format:
	uv run ruff format

typecheck:
	uv run ty check

test:
	uv run pytest

hooks:
	uv run pre-commit install

ci: lint format typecheck test
```

### 5. `AGENTS.md` — add pre-commit and test strategy sections

Add after "Commands":

```markdown
## Pre-commit hooks

Requires `pre-commit` (included in dev deps). Install once after `uv sync`:

```bash
make hooks
# or: uv run pre-commit install
```

Hooks run ruff lint + format, ty check, pytest, and a 300-line file-length
check on every commit. Skip is discouraged — CI enforces the same gates.

## Test strategy

Prefer integration tests that exercise the public interface end-to-end.
Unit-test only pure functions with non-trivial branching. Avoid mocking
internal collaborators to reach coverage targets.

Example integration test structure:

```python
# tests/integration/test_full_flow.py
def test_happy_path():
    result = run_full_pipeline(input_fixture)
    assert result.status == "success"
```
```

---

## Files changed

| File | Change |
|------|--------|
| `.pre-commit-config.yaml` | Create — gates for ruff/ty/pytest + file-length check |
| `pyproject.toml` | Add `pre-commit` devDep + `C90`/`PLR` ruff rules |
| `Makefile` | Create — `lint / format / typecheck / test / hooks / ci` targets |
| `AGENTS.md` | Add pre-commit section + test strategy |

---

## Verification

```bash
# 1. Install deps with pre-commit
uv sync && make hooks

# 2. Verify file-length hook fires
python3 -c "print('\n'.join(['x = ' + str(i) for i in range(305)]))" > tests/toobig.py
git add tests/toobig.py
git commit -m "test: should fail"  # hook should block with "has 305 lines"
git restore --staged tests/toobig.py && rm tests/toobig.py

# 3. Verify PLR rules fire on a complex function
cat > /tmp/complex.py << 'EOF'
def complex(a, b, c, d, e):
    if a: pass
    if b: pass
    # ... 55 statements
EOF
# cp to src/ and run: uv run ruff check src/complex.py

# 4. Clean commit passes
git add -A && git commit -m "test: verify hooks pass"
```
