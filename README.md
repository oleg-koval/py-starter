# py-starter

> One-line description.

[![CI](https://github.com/oleg-koval/py-starter/actions/workflows/ci.yml/badge.svg)](https://github.com/oleg-koval/py-starter/actions/workflows/ci.yml)
[![PyPI](https://img.shields.io/pypi/v/py-starter.svg)](https://pypi.org/project/py-starter/)

## Install

```bash
pip install py-starter
# or
uv add py-starter
```

## Usage

```python
from py_starter import hello

print(hello("Oleg"))  # Hello, Oleg!
```

## Development

Requires [uv](https://docs.astral.sh/uv/) (one-time install):

```bash
curl -LsSf https://astral.sh/uv/install.sh | sh   # macOS / Linux
# or: brew install uv
# Windows: powershell -c "irm https://astral.sh/uv/install.ps1 | iex"
```

Then:

```bash
uv sync                  # install deps + create .venv
uv run pytest            # run tests
uv run ruff check --fix  # lint
uv run ruff format       # format
uv run ty check          # type-check
```

## Contributing

PRs welcome. See [CONTRIBUTING.md](./CONTRIBUTING.md) and [AGENTS.md](./AGENTS.md).

## Other starters

Part of a set with shared conventions (AGENTS.md, Conventional Commits, MIT, GitHub Actions CI, Dependabot):

- [`ts-npm-starter`](https://github.com/oleg-koval/ts-npm-starter) - TypeScript / Node
- [`py-starter`](https://github.com/oleg-koval/py-starter) - Python (uv + ruff + ty) - this repo
- [`go-starter`](https://github.com/oleg-koval/go-starter) - Go (standard layout + golangci-lint)

## License

MIT - see [LICENSE](./LICENSE).
