# Repository Guidelines

## Project Structure & Module Organization
Configuration entrypoint lives in `init.lua`, which bootstraps Lazy.nvim and loads modules from the `lua/` tree. Runtime settings, keymaps, and autocmds sit under `lua/config/`, while plugin specs are grouped in `lua/plugins/` (one file per feature such as `lsp.lua`, `telescope.lua`). Persistent session data is kept in `shada/`, and plugin pins are tracked in `lazy-lock.json` so collaborators install matching versions.

## Build, Test, and Development Commands
Use Neovim itself to manage the environment. Run `nvim --headless "+Lazy sync" +qa` after pulling changes to install or update plugins per the lockfile. `nvim --headless "+Lazy check" +qa` validates that pinned plugins are available. Launch `nvim` normally to verify interactive behaviour once headless checks pass.

## Coding Style & Naming Conventions
Lua modules should remain scoped under `lua/` with snake_case filenames, mirroring their require paths (`require("config.options")`). Inside files, prefer two-space indentation, trailing commas in plugin spec tables, and local helper functions near their usage. Avoid global state—export values via return tables when needed. Keep comments short and focused on non-obvious behaviour; configuration keys themselves act as documentation.

## Testing Guidelines
Smoke-test changes by running `nvim --headless "+checkhealth" +qa` to surface missing dependencies. For plugin updates, open Neovim and run `:Lazy log` to ensure migrations succeed, then exercise targeted features (e.g., run `:Telescope find_files` when editing `telescope.lua`). Update `lazy-lock.json` only after verifying the new plugin versions behave as expected.

## Commit & Pull Request Guidelines
This directory is typically synced into your dotfiles repo; if using Git, follow short imperative commit titles that explain the behaviour change (e.g., "telescope: add live grep keymap"). Group related edits by module, and mention affected plugins in the body. Pull requests should describe the motivation, list manual test steps (`nvim --headless "+Lazy sync" +qa`), and attach screenshots or logs when UI-facing plugins are involved.

## Plugin Management Tips
Run `:Lazy restore` if you need to revert to lockfile versions after experimentation. Remove unused plugin files from `lua/plugins/` rather than disabling entries, keeping the spec clean. When adding new tools, document prerequisites (e.g., external binaries) inside the plugin file so contributors can install them ahead of time.
