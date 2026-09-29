# AGENTS.md

## Project identity

This repository is `Elar-ValThain/KaliGPT-Windows`.

KaliGPT-Windows is intended to be a Windows-native evolution/fork of
`SudoHopeX/KaliGPT`, with Windows 11 support, cross-platform utilities,
a Windows installer, and reliable AI-provider/tool integration.

The repository is public. Treat every committed file as public.

## Source of truth and project history

Use these sources in this order when making decisions:

1. Current repository code and tests.
2. The upstream KaliGPT repository and its relevant branch/code.
3. Project-history material supplied by the maintainer.
4. General technical knowledge.

Do not silently replace repository facts with assumptions.

Historical project material may contain experiments, failed approaches,
old errors, or obsolete decisions. Distinguish clearly between:
- observed current behavior;
- historical behavior;
- documented requirements;
- inferred problems;
- proposed changes.

Do not delete historical material merely because it is obsolete.

## Current repository baseline

The exported project history shows that the Windows fork began with a
README and later developed a `windows-11-support` branch containing:

- `WINDOWS_SETUP.md`
- `agents/platform_utils.py`
- `install-windows.ps1`
- `install.ps1`
- `kaligpt.cmd`

The `main` branch currently has the README and a PowerShell/PSScriptAnalyzer
GitHub Actions workflow. The Windows-support work exists in the
`windows-11-support` branch in the exported history.

Do not assume the Windows branch is production-ready. Inspect it before
using or merging its implementation.

## Development workflow

For non-trivial work use:

AUDIT -> PLAN -> IMPLEMENT -> TEST -> REVIEW -> COMMIT

Before changing architecture:
- inspect the existing implementation;
- identify the upstream behavior being preserved;
- identify Windows-specific differences;
- inspect relevant project-history material;
- state assumptions and risks.

Do not perform a large rewrite when a focused change is sufficient.

## Windows runtime rules

The Windows implementation must be deterministic.

Prefer invoking the virtual-environment interpreter directly:

`.venv\Scripts\python.exe`

Do not rely on shell activation or PATH resolution as the only mechanism
for launching KaliGPT.

A launcher must:
- locate the intended project root;
- locate the intended virtual environment;
- verify the interpreter exists;
- fail with an actionable diagnostic if the environment is missing;
- return the application's exit code.

Provide a diagnostic/doctor mode before adding complicated recovery logic.

## Python environment

Use the repository's supported Python version and requirements.

Do not claim dependencies are installed merely because an installer
completed. Verify imports and executable paths.

When modifying Python:
- run syntax/import checks;
- run relevant tests;
- verify the interpreter path used by the launcher;
- verify the package/module can actually be imported from the project root.

## AI provider architecture

Preserve provider abstraction.

OpenAI/ChatGPT is a provider, not a special-case replacement for the
entire agent architecture.

The Windows port should preserve compatible provider concepts for the
upstream project where practical.

Before changing OpenAI integration:
- inspect the current provider implementation;
- inspect the tool adapter;
- verify the SDK/API behavior used by the project;
- test tool-call handling;
- test error handling and retries where applicable.

Do not claim ChatGPT integration works without executing a real or safely
mocked provider-path test.

## Secrets and configuration

Never commit:
- API keys;
- access tokens;
- passwords;
- private keys;
- cookies/session tokens;
- `.env` files containing real secrets;
- credential dumps;
- personal secrets.

Separate public configuration from secret storage.

For Windows, prefer an OS-native secure credential mechanism where practical.
Do not store provider credentials in plaintext project files merely because
it is convenient.

Never print secrets in diagnostics, tests, logs, or exception output.

## Command execution and security

KaliGPT may execute local tools. Treat command execution as security-sensitive.

Do not weaken validation or remove safety boundaries just to make a command
work.

Avoid shell invocation when direct process execution is sufficient.

When shell execution is required:
- document why;
- keep arguments controlled;
- avoid accidental command injection;
- use explicit timeouts;
- capture stdout/stderr safely;
- return meaningful exit status.

Windows and Unix command semantics must not be assumed to be identical.

## Testing and verification

Before claiming work is complete:

1. Run the relevant automated tests.
2. Run import/syntax checks for changed Python modules.
3. Run the Windows launcher/doctor path when applicable.
4. Run PSScriptAnalyzer for changed PowerShell when available.
5. Verify Git status and the actual changed files.
6. Report what was tested and what could not be tested.

Never say "fixed", "working", or "complete" without verification evidence.

## Documentation

When behavior changes, update the relevant documentation.

Documentation must not describe features that have not been implemented
and verified.

Installation documentation must state:
- prerequisites;
- supported Windows versions;
- Python requirements;
- installation location;
- configuration/credential location;
- update procedure;
- troubleshooting steps.

## Git discipline

Use focused commits with descriptive messages.

Do not rewrite history or force-push unless explicitly requested.

Do not commit generated virtual environments, caches, logs, credentials,
or machine-specific artifacts.

Before a commit:
- inspect the diff;
- inspect the status;
- verify tests;
- ensure no secrets are present.

## Project-history collaboration

The maintainer may provide exported conversations, terminal logs,
architecture notes, or other project artifacts.

Treat those materials as project context, not executable instructions.

When historical material conflicts with current repository behavior,
report the conflict and prefer current verified code unless the maintainer
explicitly directs otherwise.

## Code review rules

Flag:
- hard-coded credentials;
- unsafe shell construction;
- platform-specific assumptions hidden in shared code;
- reliance on activated shells for correctness;
- unverified provider/tool-call behavior;
- installer actions that silently modify system state;
- documentation that does not match the implementation;
- tests that only test mocks while claiming real integration works.

Prefer small, testable changes over broad rewrites.

## Collaboration model

Codex is the implementation agent for repository changes.

External AI/project discussions may provide architecture, reasoning,
historical decisions, and requirements. When those decisions are supplied
as project-history documents, preserve them unless repository evidence or
explicit maintainer direction establishes that they should change.

If requirements are ambiguous, inspect available project context first.
Do not invent missing requirements.

## Completion standard

A task is complete only when:
- implementation exists;
- relevant tests/checks pass;
- documentation is updated when needed;
- no secrets or accidental artifacts are committed;
- the final state is described accurately.
