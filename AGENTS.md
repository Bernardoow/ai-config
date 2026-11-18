# Personal Instructions

Follow the project's instructions and established conventions. Use the style and
design preferences here where the project leaves a choice open. Apply the
authorization, Git, and security requirements across projects.

## Working approach

- Prioritize correctness, security, simplicity, and maintainability.
- Investigate relevant code and existing conventions before making changes.
- Preserve the user's existing changes and explain significant architectural decisions.
- Apply SOLID principles when they solve a concrete problem. Keep each function
  or method focused on one responsibility. Let orchestration functions
  coordinate the workflow and delegate distinct rules to focused functions.
- Prefer small functions and methods with names that express their intent.
  Extract a step when naming it helps readers follow the caller's flow without
  opening its implementation. Let cohesion and readability guide size.
- Fit extracted functions into the project's existing structure. Introduce a
  class or module when a distinct responsibility warrants its own boundary.
- Limit refactoring to code whose structure makes the requested change harder
  to implement or verify.
- Carry out requested changes and appropriate checks independently. Ask when a
  consequential decision is ambiguous.
- Explain the impact and obtain authorization before changing system configuration,
  deleting user data, running installers that change the user's environment, or
  taking other actions with significant impact outside the project. You may
  independently run installer tests in isolated temporary directories and clean
  up temporary files you create for the task.
- Prefer existing tools when they solve the problem. Check compatibility before
  adding dependencies and explain necessary additions.
- Avoid comments that merely repeat the code. Comments may explain non-obvious
  behavior or decisions.

## Use of subagents

Use subagents when isolated investigation, specialization, or parallelism
provides a concrete benefit.

- Give each subagent a clear scope, an expected outcome, and relevant project
  instructions. Require subagents to follow the repository's security and Git
  policies.
- Prefer read-only subagents for exploration and review.
- Assign separate files to subagents editing in parallel.

The main agent coordinates the work, verifies and integrates delegated results,
and delivers the final result.

## Git

Create commits, push changes, or create or publish pull requests only when
explicitly requested by the user. This rule applies even when project
conventions say otherwise.

## Tests and verification

- Preserve existing tests and follow the project's testing conventions. Update
  tests as needed when their setup or the behavior they verify changes.
- Cover new and changed behavior with tests. Review existing coverage and add
  only the cases needed to fill gaps, including relevant edge cases.
- Prefer parameterized or table-driven tests when cases share the same setup
  and assertion logic and differ only in inputs, options, or expected results.
- Investigate test failures caused by the change. Update expectations only when
  the behavior change is intentional; do not weaken tests merely to make them pass.
- Run relevant checks available in the project. When a change cannot reasonably
  be tested or test infrastructure is unavailable, explain the limitation and
  how the change was verified.

## Technology-specific conventions

Read the applicable files relative to this AGENTS.md before writing or
modifying code:

- Python: `code-conventions/python.md`
- React: `code-conventions/react.md`
- TypeScript: `code-conventions/typescript.md`

When working with React and TypeScript together, read both files.

## Security

- Keep credentials, tokens, and personal data out of code, tests, and responses.
  Use the project's established secret-management mechanism or environment variables.
- If a secret is exposed, notify the user without reproducing its value.

## Communication

Respond in the language of the user's message. Summarize changes, their purpose,
checks performed, and relevant failures or limitations, in proportion to the task.
