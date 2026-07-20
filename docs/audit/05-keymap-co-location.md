# 05 - 插件规范与 Keymap 分离

Severity: **Medium** | Category: Architecture / DX

## Problem

插件规范在 `plugins/*.lua`，对应按键在 `keymap/*.lua`，添加或删除插件需要同时编辑两个目录。

> **Note**: picker keymap 统一调用 `require("snacks").picker.*`，搜索后端固定为 Snacks。

## Current Structure

```
lua/pure-nvim/
├── plugins/
│   ├── tool.lua          # snacks.nvim spec (no keys)
│   ├── editor.lua        # flash.nvim spec (no keys)
│   └── completion.lua    # LSP spec (no keys)
├── keymap/
│   ├── tool.lua          # <leader>ff → snacks picker
│   ├── editor.lua        # flash.nvim keymaps
│   └── completion.lua    # gd, gr, K → LSP actions
└── configs/
    ├── editor/flash.lua  # flash.nvim setup
    └── completion/lsp.lua # LSP setup
```

Adding a new plugin = edit 3 files: `plugins/`, `configs/`, `keymap/`.

## LazyVim Pattern (Co-location)

```
lua/lazyvim/plugins/
├── editor.lua    # flash.nvim spec + keys + config all in one
└── lsp.lua       # LSP spec + keymaps all in one
```

Adding a new plugin = edit 1 file.

## Comparison

| Aspect | Current (Separated) | LazyVim (Co-located) |
|--------|---------------------|---------------------|
| Files to edit per plugin | 3 | 1 |
| Find all about a plugin | Check 3 dirs | Check 1 file |
| Keymap discoverability | Good (dedicated dir) | Good (in spec's `keys`) |
| Bulk keymap changes | Easy (one file) | Harder (scattered) |
| Plugin-agnostic keymaps | Natural | Need separate file anyway |

## Hybrid Approach (Recommended)

Keep the `keymap/` directory for **plugin-agnostic** keymaps (save, quit, window nav, etc.), but move **plugin-specific** keymaps into the plugin spec's `keys` field:

```lua
-- plugins/tool.lua — plugin-specific keymaps co-located
tool["folke/snacks.nvim"] = {
    keys = {
        { "<leader>ff", function() require("snacks").picker.smart() end, desc = "Find files" },
        { "<leader>fp", function() require("snacks").picker.grep() end, desc = "Live grep" },
    },
    config = require("tool.snacks"),
}

-- keymap/ui.lua — plugin-agnostic keymaps stay separate
["<leader>ww"] = { "<C-w>w", desc = "Next window" },
```

## Affected Files

| Plugin | Keymaps to move from `keymap/` to `keys` field |
|--------|------------------------------------------------|
| snacks.nvim (default picker) | `<leader>ff`, `<leader>fp`, `<leader>fg`, `<leader>fd`, etc. from `keymap/tool.lua` |
| flash.nvim | All flash keymaps from `keymap/editor.lua` |
| grug-far.nvim | `<leader>Ss`, `<leader>Sp`, `<leader>Sf` from `keymap/editor.lua` |
| gitsigns.nvim | `]g`, `[g`, `<leader>gs`, etc. from `keymap/ui.lua` |
| bufferline.nvim | `<A-1>` through `<A-9>` from `keymap/ui.lua` |
| DAP | `F6`-`F11`, `<leader>db/dc/dl/do` from `keymap/tool.lua` |

## Action

1. Identify all plugin-specific keymaps in `keymap/*.lua`
2. Move them into the corresponding `plugins/*.lua` spec's `keys` field
3. Keep `keymap/*.lua` for plugin-agnostic keymaps only
4. This is a gradual migration — can be done one plugin at a time
