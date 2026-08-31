# Syncthing workspace

`~/workspace` is synchronized between the desktop and laptop with Syncthing.
It is the source of truth for project checkouts and is mounted into the Codex
microVM at the same path.

## Working conventions

- Keep each project or Git worktree as its own directory under `~/workspace`.
- Use Git to coordinate changes between devices; do not edit the same files on
  both devices at the same time.
- Syncthing availability is not a backup. Enable folder versioning and keep an
  independent backup of important work.
- Never place private VM SSH host keys or Codex state in `~/workspace`.
  They belong under `~/.local/state/`.

## Local generated files

Python virtual environments and test/lint caches are machine-local,
reproducible artifacts. They must not be synchronized. Put this file on **both**
the desktop and laptop at `~/workspace/.stignore`:

```text
(?d)**/.venv
(?d)**/.venv-nix
(?d)**/.pytest_cache
(?d)**/.ruff_cache
(?d)**/.hypothesis
(?d)**/__pycache__
```

Syncthing never synchronizes `.stignore` itself, so changing it on one machine
does not update the other. Keep the two copies identical.

It is safe to delete ignored virtual environments and caches locally; recreate
them with the project's normal setup command, commonly `uv sync`. Do not add a
blanket ignore for `packages/`: some Arkino worktrees track source files there.
