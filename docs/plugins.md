# Plugin List

All plugins managed by [lazy.nvim](https://github.com/folke/lazy.nvim). Configs live in `lua/pure-nvim/configs/<category>/<plugin>.lua`.

Pure Neovim uses `lazy-lock-pure.json` and an isolated `site/lazy-pure` plugin root. VSCode Neovim keeps using
`lazy-lock.json` and `site/lazy` so switching environments cannot rewrite the other environment's plugin state.

## UI

| Plugin | Purpose |
|--------|---------|
| [minintro.nvim](https://github.com/eoh-bse/minintro.nvim) | Minimal start screen |
| [bufferline.nvim](https://github.com/akinsho/bufferline.nvim) | Tab-like buffer line |
| [lualine.nvim](https://github.com/nvim-lualine/lualine.nvim) | Status line |
| [rose-pine](https://github.com/rose-pine/neovim) | Color scheme (Rose Pine) |
| [neovim-theme-vitesse](https://github.com/qshan-li/neovim-theme-vitesse) | Color scheme (Vitesse) |
| [gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim) | Git diff signs in gutter |
| [indent-blankline.nvim](https://github.com/lukas-reineke/indent-blankline.nvim) | Indent guides |
| [mini.nvim](https://github.com/echasnovski/mini.nvim) | Small focused UI utilities |
| [edgy.nvim](https://github.com/folke/edgy.nvim) | Predefined window layouts |
| [paint.nvim](https://github.com/folke/paint.nvim) | Custom highlights |
| [todo-comments.nvim](https://github.com/folke/todo-comments.nvim) | TODO/FIXME highlight & search |
| [smart-splits.nvim](https://github.com/mrjones2014/smart-splits.nvim) | Smart window splits |
| [nvim-treesitter-context](https://github.com/nvim-treesitter/nvim-treesitter-context) | Sticky function context |

## Completion

| Plugin | Purpose |
|--------|---------|
| [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) | LSP client configs |
| [mason.nvim](https://github.com/williamboman/mason.nvim) | LSP/formatter/DAP installer |
| [mason-lspconfig.nvim](https://github.com/williamboman/mason-lspconfig.nvim) | Mason + lspconfig bridge |
| [nvim-cmp](https://github.com/hrsh7th/nvim-cmp) | Completion engine |
| [cmp-nvim-lsp](https://github.com/hrsh7th/cmp-nvim-lsp) | LSP completion source |
| [cmp-buffer](https://github.com/hrsh7th/cmp-buffer) | Buffer completion source |
| [cmp-path](https://github.com/hrsh7th/cmp-path) | Path completion source |
| [glance.nvim](https://github.com/DNLGL/glance.nvim) | Peek definitions/references |
| [inc-rename.nvim](https://github.com/smjonas/inc-rename.nvim) | Incremental rename |
| [neoconf.nvim](https://github.com/folke/neoconf.nvim) | Per-project LSP settings |
| [conform.nvim](https://github.com/stevearc/conform.nvim) | Formatter orchestration |
| [neocodeium](https://github.com/monkoose/neocodeium) | AI code completion |
| [tiny-code-action.nvim](https://github.com/rachartier/tiny-code-action.nvim) | Code action UI |
| [tiny-inline-diagnostic.nvim](https://github.com/rachartier/tiny-inline-diagnostic.nvim) | Inline diagnostics |

## Editor

| Plugin | Purpose |
|--------|---------|
| [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) | Syntax highlighting & parsing |
| [nvim-treesitter-textobjects](https://github.com/nvim-treesitter/nvim-treesitter-textobjects) | Treesitter text objects |
| [flash.nvim](https://github.com/folke/flash.nvim) | Fast jump/navigation |
| [Comment.nvim](https://github.com/numToStr/Comment.nvim) | Code commenting |
| [autoclose.nvim](https://github.com/m4xshen/autoclose.nvim) | Auto-close brackets |
| [nvim-ts-autotag](https://github.com/windwp/nvim-ts-autotag) | Auto-close HTML tags |
| [vim-matchup](https://github.com/andymass/vim-matchup) | Match navigation (%) |
| [grug-far.nvim](https://github.com/MagicDuck/grug-far.nvim) | Search & replace panel |
| [nvim-highlight-colors](https://github.com/brenoprata10/nvim-highlight-colors) | Color code highlighting |
| [nvim-ts-context-commentstring](https://github.com/JoosepAlviste/nvim-ts-context-commentstring) | Context-aware comments |
| [persisted.nvim](https://github.com/olimorris/persisted.nvim) | Session management |
| [rainbow-delimiters.nvim](https://github.com/HiPhish/rainbow-delimiters.nvim) | Rainbow brackets |
| [suda.vim](https://github.com/lambdalisue/suda.vim) | Read/write with sudo |
| [faster.nvim](https://github.com/pteroctopus/faster.nvim) | Large file optimizations |

## Language

| Plugin | Purpose |
|--------|---------|
| [nvim-bqf](https://github.com/kevinhwang91/nvim-bqf) | Better quickfix window |
| [crates.nvim](https://github.com/Saecki/crates.nvim) | Rust crates.io integration |
| [go.nvim](https://github.com/ray-x/go.nvim) | Go development |
| [rustaceanvim](https://github.com/mrcjkb/rustaceanvim) | Rust development |
| [render-markdown.nvim](https://github.com/MeanderingProgrammer/render-markdown.nvim) | In-buffer markdown rendering |
| [markdown-preview.nvim](https://github.com/iamcco/markdown-preview.nvim) | Browser markdown preview |

## Tool

| Plugin | Purpose |
|--------|---------|
| [nvim-tree.lua](https://github.com/nvim-tree/nvim-tree.lua) | File explorer |
| [snacks.nvim](https://github.com/folke/snacks.nvim) | Fuzzy picker (files, grep, etc.) |
| [trouble.nvim](https://github.com/folke/trouble.nvim) | Diagnostics list |
| [toggleterm.nvim](https://github.com/akinsho/toggleterm.nvim) | Terminal management |
| [which-key.nvim](https://github.com/folke/which-key.nvim) | Key binding hints |
| [dropbar.nvim](https://github.com/Bekaboo/dropbar.nvim) | Breadcrumb navigation |
| [nvim-dap](https://github.com/mfussenegger/nvim-dap) | Debug Adapter Protocol |
| [nvim-dap-ui](https://github.com/rcarriga/nvim-dap-ui) | DAP UI |
| [vim-wilder](https://github.com/gelguy/wilder.nvim) | Wildmenu enhancements |
| [smartyank.nvim](https://github.com/ibhagwan/smartyank.nvim) | Smart yank to clipboard |
