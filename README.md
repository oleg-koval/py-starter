# <PROJECT_NAME>

> One-line description.

[![CI](https://github.com/oleg-koval/<PROJECT_NAME>/actions/workflows/ci.yml/badge.svg)](https://github.com/oleg-koval/<PROJECT_NAME>/actions/workflows/ci.yml)
[![PyPI](https://img.shields.io/pypi/v/<PROJECT_NAME>.svg)](https://pypi.org/project/<PROJECT_NAME>/)

## Install

```bash
pip install <PROJECT_NAME>
# or
uv add <PROJECT_NAME>
```

## Usage

```python
from PROJECT_NAME_SNAKE import hello

print(hello("Oleg"))  # Hello, Oleg!
```

## Development

Requires [uv](https://docs.astral.sh/uv/).

```bash
uv sync                  # install deps
uv run pytest            # run tests
uv run ruff check --fix  # lint
uv run ruff format       # format
uv run ty check          # type-check
```

## Contributing

PRs welcome. See [CONTRIBUTING.md](./CONTRIBUTING.md) and [AGENTS.md](./AGENTS.md).

## License

MIT - see [LICENSE](./LICENSE).
