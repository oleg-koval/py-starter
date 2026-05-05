from py_starter import hello


def test_hello_default() -> None:
    assert hello() == "Hello, world!"


def test_hello_named() -> None:
    assert hello("Oleg") == "Hello, Oleg!"
