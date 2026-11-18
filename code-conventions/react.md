# React Conventions

Follow the project's established conventions. When the project has no convention,
use these preferences:

- Prefer Vitest and React Testing Library for component tests.
- Use `useMemo` and `useCallback` when there is a concrete reason, rather than
  applying them automatically.
- Consider custom hooks for logic with a clear responsibility or reuse opportunity.
  Test their behavior when appropriate, without extracting trivial logic solely
  to create a hook.
