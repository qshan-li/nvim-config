# Neovim Dual-Mode Configuration

A custom Neovim configuration that runs in two distinct modes, sharing core settings between them.

## Requirements

- **Neovim** >= 0.10.0
- **Git** >= 2.30
- **Nerd Font** (for icons) — recommended: [JetBrainsMono Nerd Font](https://www.nerdfonts.com/)
- **Node.js** >= 18 (for Mason-installed LSP servers)
- **fzf** >= 0.50 (required by [fzf-lua](https://github.com/ibhagwan/fzf-lua) for all pickers)
- **External tools** (optional, for full functionality):
  - [fd](https://github.com/sharkdp/fd) — fast file finder (used by fuzzy finders)
  - [ripgrep](https://github.com/BurntSushi/ripgrep) — fast grep (used by search plugins)
  - [lazygit](https://github.com/jesseduffield/lazygit) — terminal UI for git
  - [stylua](https://github.com/JohnnyMorganz/StyLua) — Lua formatter

## Installation

```bash
# 1. Back up existing config (if any)
mv ~/.config/nvim ~/.config/nvim.bak

# 2. Clone this repo
git clone https://github.com/<your-username>/nvim ~/.config/nvim

# 3. Launch Neovim — plugins install automatically via lazy.nvim
nvim
```

## Architecture

**Dual-Mode Design**: The config detects `vim.g.vscode` at startup and loads the appropriate mode:

- **`lua/shared/`** — Loaded first in both modes. Contains options (leader key, nerd font), keymaps, and shared plugin specs.
- **`lua/pure-nvim/`** — Loaded only in standalone Neovim. Full-featured: lazy.nvim plugin manager, LSP, completion, UI, etc.
- **`lua/vscode-nvim/`** — Loaded only inside VSCode Neovim extension. Minimal: keymaps and a small plugin set.

**Constraint**: VSCode paths are immutable. Shared logic lives in `lua/shared/`, not duplicated.

## Boot Sequence

```
init.lua → require("shared").setup() → detects vim.g.vscode → loads either pure-nvim or vscode-nvim
```

Pure Neovim sets `vim.g.pure_nvim = true` early in its init.

## Plugin Management (Pure Neovim)

Uses **lazy.nvim**. Plugin specs are split by category in `lua/pure-nvim/plugins/`:

- `ui.lua` — UI enhancements
- `lang.lua` — Language support
- `completion.lua` — Completion plugins
- `editor.lua` — Editor features
- `tool.lua` — Development tools

Per-plugin configs live in `lua/pure-nvim/configs/<category>/<plugin>.lua`.

## Settings

Key settings are centralized in `lua/pure-nvim/core/settings.lua`:

- `use_ssh` — Use SSH for plugin updates (default: true)
- `format_on_save` — Enable format on save (default: true)
- `format_timeout` — Format timeout in ms (default: 1000)
- `format_notify` — Show format notifications (default: false)
- `colorscheme` — Active color scheme (default: `rose-pine`; also `rose-pine-main`, `rose-pine-moon`, `rose-pine-dawn`)
- `mason_lsp_servers` — LSP servers to install (frontend only: `html`, `jsonls`, `lua_ls`, `marksman`, `vtsls`, `vue_ls`)
- `mason_tools` — Formatters to install (`prettier`, `shfmt`, `stylua`)

## Directory Structure

```
lua/
├── shared/           # Shared between both modes
│   ├── init.lua
│   ├── options.lua
│   ├── keymaps.lua
│   └── i18n.lua
├── pure-nvim/        # Standalone Neovim config
│   ├── core/         # Core modules (options, events, pack, keymap)
│   ├── plugins/      # Plugin specs by category
│   └── configs/      # Per-plugin configurations
└── vscode-nvim/      # VSCode Neovim extension config
    └── init.lua
```

## Documentation

- [Keymap Cheatsheet](docs/keymap-cheatsheet.md) — quick reference for all keybindings
- [Plugin List](docs/plugins.md) — all plugins and their purposes

## Build / Lint / Test

- **No build step** — config loads directly.
- **Smoke test**: `nvim -u init.lua +"qa"` (full) or `nvim -u lua/pure-nvim/init.lua +"qa"` (pure Neovim only).
- **Format**: `stylua init.lua lua/` — uses tabs, 120 char width, double quotes (see `stylua.toml`).

## Code Style

- **Lua only** — no new Vimscript.
- Idempotent setup pattern: `if M.loaded then return end` at top of `M.setup()`.
- Plugin specs use Lazy format: `{ "author/plugin", opts = ..., keys = ... }`.
- Options use `vim.o` or `vim.opt`; keymaps use `vim.keymap.set` with `{ desc = ... }`.
- Conventional commits preferred (feat:, fix:, refactor:).

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

## License

[MIT](LICENSE)
