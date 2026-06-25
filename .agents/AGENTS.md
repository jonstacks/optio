# Project Rules & Preferences

## Local Development Toolchain & Dependency Management

- **Flox Environment**: This project uses **Flox** (`.flox/`) to manage and lock local development dependencies, including `nodejs_22`, `pnpm_10`, `kubectl`, `kubernetes-helm`, and `openssl`.
- **Automatic Shell Activation**: The root `.envrc` uses direnv's built-in `use flox` stdlib directive to automatically activate the Flox environment in direnv-enabled interactive shells.
- **Running Commands outside Direnv**: When running terminal commands or scripts in shells where direnv / Flox is not automatically activated, wrap commands using `flox activate -c "<cmd>"` (or `flox activate -- <cmd>`) to ensure the correct locked tool versions are used.
