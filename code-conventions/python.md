# Python Conventions

Follow the project's established conventions and Python version. When the project
has no convention, use these preferences:

- Type-hint parameters and return values of all new functions and methods,
  including private ones. Annotate variables when useful.
- Prefer the most modern type syntax supported by the project's Python version,
  such as `str | None` and `list[str]`.
- Make parameters of new functions and methods keyword-only using `*` where
  practical. Preserve signatures required by frameworks, protocols, or
  compatibility; `self` and `cls` remain positional.
- Use `typing.Protocol` for structural interfaces when appropriate.
- Prefer Black with a line length of 99 characters.
- Use `@patch` when mocking is necessary and appropriate.
- Group related pytest tests in regular classes, including when starting with a
  single test. Follow the project's existing test organization when it differs.
