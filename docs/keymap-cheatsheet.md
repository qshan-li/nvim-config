# Keymap Cheatsheet

Leader key: `<Space>` (set in `shared/options.lua`)

## General (Shared)

| Key | Mode | Description |
|-----|------|-------------|
| `H` | n, v | Go to start of line (`^`) |
| `L` | n, v | Go to end of line (`$`) |
| `jk` / `kj` | i | Exit insert mode |
| `<C-h/j/k/l>` | n | Focus window left/down/up/right |
| `<Esc><Esc>` | t | Exit terminal mode |
| `<leader>lq` | n | Open diagnostic quickfix list |
| `<leader>qq` | n | Force quit all |
| `<leader>ta` | n | Toggle i18n language |
| `<leader>rr` | n | Copy file path (absolute) |
| `<leader>rd` | n | Copy directory path |
| `<leader>O1` | n | Open in system explorer |
| `<leader>O2` | n | Open in WSL explorer |
| `<leader>O3` | n | Open image in Windows viewer |
| `<C-CR>` | n | Add empty line below |

## Editing (Pure Neovim)

| Key | Mode | Description |
|-----|------|-------------|
| `<C-s>` | n, i | Save file |
| `<C-q>` | n, i | Save and quit |
| `<A-S-q>` | n | Force quit |
| `Y` | n | Yank to end of line |
| `D` | n | Delete to end of line |
| `n` / `N` | n | Next/prev search result (centered) |
| `J` | n | Join next line |
| `V` / `K` | v | Move selection down/up |
| `<` / `>` | v | Decrease/increase indent |
| `<A-/>` | n, x | Toggle line comment |
| `<A-s>` | n | Save with sudo |

## Session

| Key | Mode | Description |
|-----|------|-------------|
| `<leader>sp` | n | Pick session |
| `<leader>ss` | n | Save session |
| `<leader>sl` | n | Load current session |
| `<leader>sd` | n | Delete current session |

## Search & Find

| Key | Mode | Description |
|-----|------|-------------|
| `<leader>ff` | n | Find files (fzf-lua) |
| `<leader>fp` | n | Live grep (fzf-lua) |
| `<leader>fs` | v | Grep word under cursor |
| `<leader>fg` | n | Git status |
| `<leader>fd` | n | Workspace diagnostics |
| `<leader>fm` | n | Keymaps |
| `<leader>fR` | n | Resume last search |
| `<leader>fc` | n | Picker list (all builtin pickers) |

## Flash (Jump)

| Key | Mode | Description |
|-----|------|-------------|
| `s` | n, x, o | Jump to location |
| `S` | n, x, o | Treesitter jump |
| `<leader>w` | n, v | Jump to word |
| `<leader>j/k` | n, v | Jump to line |
| `<leader>c/C` | n, v | Jump to chars |

## Search & Replace

| Key | Mode | Description |
|-----|------|-------------|
| `<leader>Ss` | n | Open search & replace panel |
| `<leader>Sp` | n, v | Search & replace word (project) |
| `<leader>Sf` | n | Search & replace word (file) |

## Treesitter Text Objects

| Key | Mode | Description |
|-----|------|-------------|
| `af` / `if` | x, o | Select outer/inner function |
| `ac` / `ic` | x, o | Select outer/inner class |
| `][` / `]]` | n, x, o | Next function start/end |
| `[[` / `[]` | n, x, o | Previous function start/end |
| `]m` / `[m` | n, x, o | Next/prev class start |
| `]M` / `[M` | n, x, o | Next/prev class end |
| `;` | n, x, o | Repeat last move |

## LSP

| Key | Mode | Description |
|-----|------|-------------|
| `gd` | n | Go to definition |
| `gD` | n | Preview definition |
| `gr` | n | Rename (in file range) |
| `gR` | n | Rename (in project range) |
| `gs` | n | Signature help |
| `gh` | n | Hover or diagnostics |
| `gm` | n | Show implementation |
| `gci` / `gco` | n | Incoming/outgoing calls |
| `K` | n | Show documentation |
| `<A-f12>/` | n, v | Code action |
| `<leader>li` | n | LSP info (`:checkhealth vim.lsp`) |
| `<leader>lr` | n | Restart LSP (`:lsp restart`) |
| `<leader>lv` | n | Toggle diagnostic virtual text |
| `<leader>lh` | n | Toggle inlay hints |
| `<leader>lu` | n | Go to references |

## Formatting

| Key | Mode | Description |
|-----|------|-------------|
| `<A-f>` | n | Toggle format on save |
| `<A-S-f>` | n | Format buffer manually |

## AI Completion (Neocodeium)

| Key | Mode | Description |
|-----|------|-------------|
| `<A-f>` | i | Accept suggestion |
| `<A-w>` | i | Accept word |
| `<A-a>` | i | Accept line |
| `<A-e>` | i | Cycle or complete |
| `<A-r>` | i | Cycle reverse |
| `<A-c>` | i | Clear suggestion |

## Git

| Key | Mode | Description |
|-----|------|-------------|
| `]g` / `[g` | n | Next/prev hunk |
| `<leader>gs` | n, v | Stage hunk |
| `<leader>gr` | n, v | Reset hunk |
| `<leader>gR` | n | Reset buffer |
| `<leader>gp` | n | Preview hunk |
| `<leader>gb` | n | Blame line |
| `<leader>gg` | n | Toggle lazygit |

## Terminal

| Key | Mode | Description |
|-----|------|-------------|
| `<C-\\>` | n, i, t | Toggle horizontal terminal |
| `<A-\\>` | n, i | Toggle vertical terminal |
| `<A-d>` | n, i, t | Toggle float terminal |
| `<F5>` | n, i, t | Toggle vertical terminal |
| `<C-p>` | n, i, t | Toggle panel terminal |
| `<leader>tt` | n | Toggle panel terminal |
| `<leader>tn` | n | New terminal |
| `<leader>tp` | n | Pick terminal |
| `<leader>tr` | n | Rename terminal |
| `<leader>tq` | n | Kill terminal |
| `<A-1..9>` | n | Switch to buffer 1-9 |
| `<A-1..9>` | t | Switch to panel terminal 1-9 |
| `]T` / `[T` | n | Next/prev panel terminal |
| `<C-n>` | t (in terminal) | New terminal instance |

## Diagnostics & Symbols

| Key | Mode | Description |
|-----|------|-------------|
| `<leader>fd` | n | Workspace diagnostics (fzf-lua) |
| `gto` | n | Workspace symbols (fzf-lua) |
| `<leader>lj/lk` | n | Next/prev diagnostic |

## Window & Buffer

| Key | Mode | Description |
|-----|------|-------------|
| `<A-h/j/k/l>` | n | Resize window |
| `<A-S-i/o>` | n | Move buffer next/prev |
| `<A-q>` | n | Close buffer |
| `<leader>bn` | n | New buffer |
| `<C-Tab>` | n | Buffer picker |

## File Tree (NvimTree)

| Key | Mode | Description |
|-----|------|-------------|
| `<leader>e` | n | Toggle file tree |
| `E` | n | Find current file in tree |

## Markdown

| Key | Mode | Description |
|-----|------|-------------|
| `<F1>` | n | Toggle in-Nvim markdown preview |
| `<F12>` | n | Toggle browser markdown preview |

## Package Manager (Lazy)

| Key | Mode | Description |
|-----|------|-------------|
| `<leader>ph` | n | Show Lazy UI |
| `<leader>ps` | n | Sync plugins |
| `<leader>pu` | n | Update plugins |
| `<leader>pi` | n | Install plugins |

## Theme

| Key | Mode | Description |
|-----|------|-------------|
| `<leader>u` | n | Switch theme |
