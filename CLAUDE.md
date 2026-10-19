# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Dual-Mode Architecture

This is a Neovim config that runs in two distinct modes, detected at startup via `vim.g.vscode`:

- **`lua/shared/`** — loaded first in both modes. Contains options (leader key, nerd font), keymaps, and shared plugin specs. Entry: `shared.init.lua` → calls `shared.options.setup()` + `shared.keymaps.setup()`.
- **`lua/vscode-nvim/`** — loaded only inside VSCode Neovim extension. Minimal: just keymaps and a small plugin set.
- **`lua/pure-nvim/`** — loaded only in standalone Neovim. Full-featured: plugin manager (lazy.nvim), LSP, completion, UI, etc.

**Constraint**: VSCode paths are immutable — never refactor or "optimize" VSCode-side code. Shared logic must live in `lua/shared/`, not duplicated into either side.

## Boot Sequence

`init.lua` → `require("shared").setup()` → detects `vim.g.vscode` → loads either `pure-nvim` or `vscode-nvim`. Pure Neovim sets `vim.g.pure_nvim = true` early in its init.

Pure Neovim boot chain: `pure-nvim/core/init.lua` → creates cache dirs → sets up clipboard/shell/GUI → loads core options → events → pack (lazy.nvim bootstrap) → keymap → applies colorscheme.

## Plugin Management (Pure Neovim)

Uses **lazy.nvim**. Plugin specs are split by category in `lua/pure-nvim/plugins/` (ui, lang, completion, editor, tool). Each file returns a table keyed by plugin name → config. The pack loader auto-globs `plugins/*.lua` and merges everything.

Per-plugin configs live in `lua/pure-nvim/configs/<category>/<plugin>.lua` — these are on the Lua path via `package.path` manipulation in `pack.lua`, so plugin specs reference them as `require("ui.bufferline")`, `require("tool.nvim-tree")`, etc. (pattern: `require("<category>.<plugin>")`).

Settings (colorscheme, SSH vs HTTPS, disabled plugins, GUI font, neovide config) are centralized in `lua/pure-nvim/core/settings.lua`.

## Build / Lint / Test

- **No build step** — config loads directly.
- **Smoke test**: `nvim -u init.lua +"qa"` (full) or `nvim -u lua/pure-nvim/init.lua +"qa"` (pure Neovim only).
- **Format**: `stylua init.lua lua/` — uses tabs, 120 char width, double quotes (see `stylua.toml`).
- **Manual verification required**: open `nvim`, confirm no errors, test modified functionality.

## Code Style

- **Lua only** — no new Vimscript.
- Idempotent setup pattern: `if M.loaded then return end` at top of `M.setup()`.
- Plugin specs use Lazy format: `{ "author/plugin", opts = ..., keys = ... }`.
- Options use `vim.o` or `vim.opt`; keymaps use `vim.keymap.set` with `{ desc = ... }`.
- File naming: lowercase with hyphens or underscores.
- Conventional commits preferred (feat:, fix:, refactor:).
