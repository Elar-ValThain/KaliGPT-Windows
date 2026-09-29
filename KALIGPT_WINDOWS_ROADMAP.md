# KaliGPT-Windows Architecture and Roadmap

## Purpose

This document records the current baseline and intended implementation
sequence for `Elar-ValThain/KaliGPT-Windows`.

It is derived from the exported project history supplied by the maintainer.
It is a planning document, not proof that any planned feature currently
exists.

## Current baseline

The exported Git history contains:

- `main`
  - README
  - `.github/workflows/powershell.yml`
- `windows-11-support`
  - `WINDOWS_SETUP.md`
  - `agents/platform_utils.py`
  - `install-windows.ps1`
  - `install.ps1`
  - `kaligpt.cmd`

The Windows-support branch contains the substantive Windows-port work.
The main branch is still minimal.

## Existing Windows-port concepts

The historical implementation attempts to provide:

- Windows platform detection;
- cross-platform command execution;
- platform-specific config/cache paths;
- browser launching;
- virtual-environment helpers;
- ANSI terminal detection;
- PowerShell installation;
- virtual environment creation;
- dependency installation;
- optional Ollama setup;
- API-key setup;
- a `kaligpt.cmd` launcher;
- PATH integration;
- update/version/help modes.

These should be treated as an existing prototype, not as verified production
behavior.

## Known architectural problems to resolve

### 1. Launcher determinism

The historical launcher activates `.venv` and then invokes `python`.

Target behavior:

`.venv\Scripts\python.exe -m agents ...`

The launcher should not depend on whichever Python executable happens to
win PATH resolution.

### 2. Installer isolation

The historical installer clones the upstream repository into the install
directory and installs from upstream requirements.

The Windows fork needs a clear decision about whether it is:

- a standalone distributable;
- a patch/fork layered over upstream;
- or an installer that fetches upstream at installation time.

Do not silently mix these models.

### 3. Branch/install consistency

Historical documentation references `windows-11-support`, while the main
branch contains the current workflow. Installation/update behavior must
identify the intended source and branch explicitly.

### 4. Configuration and credentials

Historical documentation points to:

`%APPDATA%\KaliGPT\api.config.json`

The final design should separate normal configuration from secret material
and prefer secure Windows credential storage for provider secrets.

### 5. Cross-platform command execution

`agents/platform_utils.py` provides a prototype abstraction, but command
parsing and shell invocation need security-focused testing.

The Windows path should distinguish:
- direct executable invocation;
- argument lists;
- shell syntax requiring `cmd.exe` or PowerShell.

### 6. Provider/tool integration

The Windows port should preserve the upstream provider abstraction.

OpenAI/ChatGPT should remain an AI provider backed by the agent/tool layer,
not become a separate Windows-only application path.

Tool calls must be tested against the provider implementation actually used
by the repository.

## Target architecture

```text
KaliGPT-Windows
|
+-- CLI / launcher
|   +-- deterministic Python selection
|   +-- doctor
|   +-- help/version
|
+-- Agent layer
|   +-- provider abstraction
|   +-- tool orchestration
|   +-- conversation state
|
+-- Providers
|   +-- OpenAI / ChatGPT
|   +-- Gemini
|   +-- Ollama
|   +-- OpenRouter
|   +-- other upstream-compatible providers
|
+-- Tools
|   +-- Windows-native tools
|   +-- cross-platform tools
|   +-- web/search tooling
|
+-- Configuration
|   +-- public settings
|   +-- secure credentials
|
+-- Installer
|   +-- prerequisite checks
|   +-- venv/bootstrap
|   +-- launcher installation
|
+-- Tests
|   +-- unit
|   +-- provider/tool integration
|   +-- Windows launcher
|   +-- installer validation
|
+-- CI
    +-- PowerShell analysis
    +-- Python checks
    +-- tests
```

## Implementation sequence

### Phase 0: Repository audit

- inspect both branches;
- compare with upstream;
- identify exact dependency model;
- identify current entry points;
- inventory historical project decisions;
- establish tests that can run on Windows.

Deliverable: written baseline.

### Phase 1: Deterministic runtime

- implement reliable launcher;
- add environment validation;
- add `kaligpt --doctor`;
- verify module discovery from project root;
- add tests for missing venv/interpreter.

### Phase 2: Installer

- make installation idempotent;
- avoid silently cloning over existing directories;
- explicitly select source/branch;
- verify dependencies after installation;
- create launcher;
- provide actionable failure messages.

### Phase 3: Configuration and credentials

- define configuration schema;
- separate secrets from ordinary settings;
- implement secure Windows secret storage where practical;
- add migration path from historical plaintext configuration.

### Phase 4: Provider layer

- verify OpenAI/ChatGPT provider;
- verify current SDK usage;
- verify tool adapter;
- add provider error handling;
- add mocked tests;
- add optional live integration test path without requiring secrets in CI.

### Phase 5: Windows tools

- port required Linux assumptions to Windows equivalents;
- preserve safe command execution;
- add explicit platform capability detection;
- avoid pretending Linux-only utilities exist on Windows.

### Phase 6: CI and release

- Python tests;
- PowerShell analysis;
- installer validation;
- packaging/release workflow;
- documentation synchronization.

## Definition of done

A release candidate should have:

- deterministic launch behavior;
- reproducible installation;
- secure credential handling;
- verified provider selection;
- verified OpenAI tool calls;
- automated tests;
- PowerShell CI;
- accurate Windows documentation;
- no secrets in Git history or working-tree artifacts;
- clear troubleshooting and diagnostic output.
