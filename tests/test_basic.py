from PROJECT_NAME_SNAKE import hello


def test_hello_default() -> None:
    assert hello() == "Hello, world!"


def test_hello_named() -> None:
    assert hello("Oleg") == "Hello, Oleg!"
