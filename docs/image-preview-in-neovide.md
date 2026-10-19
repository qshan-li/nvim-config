# 在 Neovide 中预览图片：调研报告

> 调研日期：2026-08-25。环境：WSL2 (WSLg) + Neovide + 本仓库（lazy.nvim，pure-nvim 侧）。
>
> 后续更新（2026-10-19）：本仓库已移除 `folke/snacks.nvim`，picker 改为 `fzf-lua`。本文中与 snacks.image 相关的建议需要重新评估；Neovide 主路径（`<leader>O3` 调用 Windows 查看器）已落地。

## TL;DR（结论先行）

**Neovide 目前完全不支持编辑器内联渲染图片**——它既不实现 Kitty Graphics Protocol，也不支持 Sixel，这是 Neovide 自身的缺失，任何插件都无法绕过。因此：

1. **不要**为了 Neovide 安装 `3rd/image.nvim` 或启用 `hologram.nvim`——作者已明确声明不支持 Neovide（[image.nvim#90](https://github.com/3rd/image.nvim/issues/90)）。
2. **推荐双轨方案**：
   - **Neovide 主路径**：自定义一个「用系统查看器打开图片」的快捷键（零新增依赖，WSL 下调 `explorer.exe` 用 Windows 照片查看器打开），本仓库只需改 3 个文件即可落地，见[集成方案](#五针对本仓库的集成方案)。
   - **终端副路径**：本仓库先前装有 `folke/snacks.nvim`（2026-10 已移除），其 **image 模块**（snacks.image）开箱即用，仅依赖 ImageMagick；在支持 Kitty Graphics Protocol 的终端（kitty / ghostty，均可通过 WSLg 运行 Linux 版）里可自动获得 Markdown 内联图、hover 预览等能力，在不支持的终端/Neovide 下默认自动跳过（`force = false`）。
3. 若未来 Neovide 合并 [PR #3039](https://github.com/neovide/neovide/pull/3039)（目前仍是 draft，且依赖已被关闭的上游 neovim PR），内联渲染才有可能原生可用。

---

## 一、Neovide 本身的图片渲染能力

**结论：不支持。**

- 官方文档 Features 页没有任何「图片渲染」条目，图形相关能力仅提到 emoji 通过字体回退渲染（"Font fallback supports rendering of emoji not contained in the configured font."）。来源：[Neovide Features](https://neovide.dev/features.html)。FAQ 页同样没有图片相关条目（[FAQ](https://neovide.dev/faq.html)）。
- Kitty Graphics Protocol 支持是长期需求但至今未实现：
  - [Issue #2088 "Support image.nvim / Kitty Graphics Protocol / image rendering in Neovide"](https://github.com/neovide/neovide/issues/2088)（2023-10 提出，已关闭但功能未落地）；维护者 Kethku 于 2026-06-09 评论："There has been some upstream progress, but until it settles a bit, it is unlikely to make progress here."（需等待 neovim 上游先稳定）。
  - [Draft PR #3039 "feat: image rendering support"](https://github.com/neovide/neovide/pull/3039)（2025-03 发起，至今仍是 draft，最后更新 2025-04）依赖上游 [neovim PR #31399 "feat(img): implement rudimentary image API"](https://github.com/neovim/neovim/pull/31399)，而后者已于 2026-02 **关闭未合并**。
  - 上游 [neovim#39434](https://github.com/neovim/neovim/issues/39434) 进一步指出：现有 `vim.ui.img` 直接向 stdout 发送终端转义序列，"That means it doesn't work on GUIs such as Neovide"，需要为 GUI 设计专门的 UI event 协议。

**原理**：Kitty Graphics Protocol / Sixel 都是通过终端转义序列传图的机制，只有「终端模拟器」负责解析并把像素画到窗口上。Neovide 是自绘 GUI（GPU 渲染网格），不解析这些序列，所以所有依赖此类协议的插件在 Neovide 中都无效。

---

## 二、图片预览插件对比

| 插件 | 后端 | 支持 Neovide？ | 主要依赖 | 维护状态 |
|---|---|---|---|---|
| [3rd/image.nvim](https://github.com/3rd/image.nvim) | kitty（最佳）、wezterm（有限、官方不支持）、ghostty（实验性）、ueberzugpp、sixel；tmux 全后端透传 | ❌ 作者确认不支持 | ImageMagick（必须）；luarocks 仅 `magick_rock` 处理器需要；Ghostscript 渲染 PDF；cURL 远程图 | 活跃 |
| [folke/snacks.nvim] image 模块 ([docs/image.md](https://github.com/folke/snacks.nvim/blob/main/docs/image.md)) | kitty、ghostty、wezterm（inline 不支持）、tmux（passthrough）；zellij 明确不支持 | ❌（文档通篇无 Neovide；依赖终端实现 KGP） | ImageMagick（png 以外的格式转换）；文档内联预览还需对应 treesitter parser | 活跃，**本仓库已安装** |
| [edluffy/hologram.nvim](https://github.com/edluffy/hologram.nvim) | kitty graphics protocol | ❌ | — | 最后提交 2023-11，实质停止维护 |
| [nvim-telescope/telescope-media-files.nvim](https://github.com/nvim-telescope/telescope-media-files.nvim) | ueberzug / viu / chafa 缩略图 | ueberzug/viu 仅限终端；chafa 输出 ANSI 字符画，理论上任何 GUI 可显示 | chafa 等 | 最后提交 2024-03，停滞 |
| [adelarsq/image_preview.nvim](https://github.com/adelarsq/image_preview.nvim) | WezTerm/Kitty 协议 + 外部程序 | ❌（README 环境清单中 WSL 未勾选） | — | 活跃（2026-05 有更新），但不适配本场景 |

### 2.1 3rd/image.nvim 要点

- 后端说明来自其 README：kitty 后端 "best in class"；wezterm 性能差且不完全合规、"not officially supported"；sixel 需要 ImageMagick 的 Sixel 构建。tmux ≥ 3.3 且开启 `allow-passthrough` 时全后端可用。
- **对 Neovide 的官方态度**：作者在 [issue #90](https://github.com/3rd/image.nvim/issues/90) 回复："There's no support to Neovide, it's meant for terminal emulators, mainly for Kitty." 另见同类问题 [#203](https://github.com/3rd/image.nvim/issues/203)。
- 与 snacks.image 无从属关系：两者是相互独立的 Kitty Graphics Protocol 实现。

### 2.2 folke/snacks.nvim image 模块要点（推荐关注的方案）

以下引自官方文档 [docs/image.md](https://github.com/folke/snacks.nvim/blob/main/docs/image.md)：

- 功能：打开图片文件即显示；在 `markdown`、`html`、`norg`、`tsx`、`css`、`latex`、`typst` 等文件中**内联渲染图片**；LaTeX 数学公式渲染；`Snacks.image.hover()` 光标处悬浮预览；支持 png/jpg/gif/webp/tiff/heic/avif 以及视频（mp4/mkv…）、pdf、icns。
- 终端支持原文："kitty / ghostty / wezterm (Inline image rendering is not supported.) / tmux … zellij is **not** supported"。**Neovide 未列入**。
- 依赖：仅 ImageMagick（"ImageMagick is required to convert images to the supported formats (all except PNG)."）；不需要 luarocks（那是 image.nvim 的 magick_rock 才需要的）。
- 安全性：配置项 `force = false -- try displaying the image, even if the terminal does not support it`，即默认情况下终端不支持时**不会强行发转义序列**，在 Neovide 中保持静默跳过；排障用 `:checkhealth snacks`。
- 注意：其功能列表中**没有**「剪贴板截图 → 保存文件」能力（image.nvim 同样没有），粘贴截图属于另一类需求，不在本方案范围内。

---

## 三、WSL2 / WSLg 的特殊性

- **根本阻碍与 WSLg 无关**：Neovide 不解析图形协议是全局事实，WSLg 只是 Wayland/X11 显示层。GitHub 上不存在「WSLg 下 Neovide 图片」专项 issue，因为该组合在任何平台都不工作。Neovide 在 WSL2 的已知问题集中在启动与环境：
  - [#2662 wsl2 can't open neovide window](https://github.com/neovide/neovide/issues/2662)、[#2227 Can't open neovide with wslg.exe](https://github.com/neovide/neovide/issues/2227)、[#2590 XKBNotFound panic](https://github.com/neovide/neovide/issues/2590)、[#3160 Broken pipe on Manjaro WSL](https://github.com/neovide/neovide/issues/3160)、[#3083 Neovide doesn't respect WSL environment settings](https://github.com/neovide/neovide/issues/3083)；
  - 剪贴板怪癖：[#3429](https://github.com/neovide/neovide/issues/3429)、[#2260](https://github.com/neovide/neovide/issues/2260)。
- **Windows Terminal 不支持 Kitty Graphics Protocol**，所以在 wt.exe 里跑纯 nvim 也无法内联看图；想要真正的内联渲染，需通过 WSLg 运行 **Linux 版 kitty 或 ghostty**（二者都是普通 GUI 应用，WSLg 可以直接启动），此时 snacks.image 即可工作。
- **调用 Windows 侧查看器**：WSL 中可直接执行 `/mnt/c/Windows/explorer.exe <file>`（或安装 `wslu` 后用 `wslview <file>`）用 Windows 默认程序打开文件，这是 Neovide 下最实用的「看图」路径。

---

## 四、具体使用场景

### 4.1 Markdown 内联预览

- 可行路径：kitty/ghostty 终端 + `snacks.image`（`doc.inline = true`，需 treesitter markdown parser）。来源：[snacks docs/image.md](https://github.com/folke/snacks.nvim/blob/main/docs/image.md)。
- Neovide 下不可行（见第一节）。
- 备注：本仓库已装 [MeanderingProgrammer/render-markdown.nvim](https://github.com/MeanderingProgrammer/render-markdown.nvim)（`lua/pure-nvim/plugins/lang.lua`），它负责 Markdown 排版美化，但不渲染位图；另有 iamcco/markdown-preview.nvim 可走浏览器预览（含图片），是 Neovide 下查看 Markdown 成品的现成替代。

### 4.2 Telescope / Picker 预览图片

**仓库现状勘误**：本仓库实际**并未安装 nvim-telescope/telescope.nvim**——`lazy-lock-pure.json` 中没有 telescope/fzf-lua 条目，`lua/` 全目录也无 telescope 引用；日常 picker 是 **snacks.picker**（见 `lua/pure-nvim/keymap/tool.lua` 大量 `require("snacks").picker.*` 调用）。CLAUDE.md 中提及 telescope/fzf-lua 属过时描述。

通用答案（无论 picker 为何）：
- Telescope 生态的图片方案主要是 [telescope-media-files.nvim](https://github.com/nvim-telescope/telescope-media-files.nvim)（已停滞，ueberzug 后端仅限终端）；chafa 后端输出 ANSI 字符画，理论上可在 Neovide 显示（[Chafa](https://hpjansson.org/chafa/)），但需自行写自定义 previewer，且插件本身无人维护。
- snacks.picker 本身不渲染位图。
- **务实做法**：给文件类 picker 加一个「用系统查看器打开」动作/快捷键（见下方集成方案的 `<leader>ii`），在 Neovide 中浏览目录时选中图片一键调起外部查看器。

### 4.3 Hover 悬浮预览

- `Snacks.image.hover()` —— "Show the image at the cursor in a floating window"（光标停在图片链接上触发）。来源：[snacks docs/image.md](https://github.com/folke/snacks.nvim/blob/main/docs/image.md)。仅在 KGP 终端下生效。

### 4.4 打开图片文件即预览

- 启用 snacks.image 后，直接 `:e foo.png` 即由 image buffer 显示（同上来源）。Neovide 下会回退为二进制/文本视图，属预期行为。

---

## 五、针对本仓库的集成方案

遵循仓库架构：改动全部位于 `lua/pure-nvim/` 侧（VSCode 路径不动）；配置外置到 `settings.lua`；错误显式抛出而非静默。

### 步骤 0：安装系统依赖（一次性）

```bash
sudo apt-get update && sudo apt-get install -y imagemagick
# 可选：PDF 预览支持
sudo apt-get install -y ghostscript
```

不需要 luarocks（那是 image.nvim 的 magick_rock 才需要的，本方案不用 image.nvim）。

### 步骤 1：`lua/pure-nvim/core/settings.lua` —— 新增外置配置

在文件末尾 `return settings` 之前追加（风格对齐现有条目）：

```lua
-- External viewer command used to preview images that cannot be rendered in-buffer
-- (e.g. inside Neovide). On WSLg prefer a Windows-side viewer:
--   { "explorer.exe" } or { "wslview" }; on native Linux use { "xdg-open" }.
---@type string[]
settings["image_viewer_cmd"] = { "explorer.exe" }
```

### 步骤 2：`lua/pure-nvim/plugins/tool.lua` —— 启用 snacks.image 模块

把现有的 `opts = snacks_picker_opts` 改为合并后的表（沿用文件顶部局部变量的既有风格）：

```lua
local snacks_image_opts = {
	image = {
		-- force defaults to false: unsupported terminals (Neovide, plain TUI)
		-- are skipped silently instead of emitting garbage escape codes.
		doc = {
			inline = true,
			float = true,
		},
	},
}
local snacks_opts = vim.tbl_deep_extend("force", snacks_picker_opts, snacks_image_opts)

tool["folke/snacks.nvim"] = {
	lazy = true,
	event = "VeryLazy",
	opts = snacks_opts,
}
```

无需新建 config 文件——snacks.nvim 在本仓库就是纯 `opts` 驱动的。

### 步骤 3：`lua/pure-nvim/keymap/tool.lua` —— Neovide 主路径：外部查看器

在 `mappings.plugins` 表中追加（前缀 `<leader>p*` 已被 lazy.nvim 包管理占用、`<leader>o` 已被 spell 占用，故选用空闲的 `<leader>i`）：

```lua
["n|<leader>ii"] = map_callback(function()
		local viewer = require("pure-nvim.core.settings")["image_viewer_cmd"]
		local file = vim.fs.normalize(vim.fn.expand("<cfile>"))
		if vim.fn.filereadable(file) == 0 then
			error(("image-preview: file not readable: %s"):format(file))
		end
		vim.system(vim.list_extend(viewer, { file }), { detach = true })
	end)
	:with_noremap()
	:with_silent()
	:with_desc("editor: Open image under cursor externally"),
```

用法：光标放在 Markdown 的图片路径/相对链接上按 `<leader>ii`，或在 netrw/nvim-tree 光标停在图片文件上触发。配合 snacks.picker 的 `files` source 也能先搜到图片再回车打开（picker 默认回车是打开 buffer；如需 picker 内直达外部查看器，可后续再加自定义 action，此处不展开）。

### 步骤 4：验证

```bash
# 冒烟测试（CLAUDE.md 规定）
nvim -u init.lua +"qa"
```

- 在 Neovide 中：`:e some.png` 应显示原始内容且无报错；`<leader>ii` 应弹出 Windows 查看器。
- 在 kitty/ghostty（WSLg）中：`:e some.png` 应直接渲染图片；Markdown 内联图生效；运行 `:checkhealth snacks` 确认终端检测通过。
- 手动验证要求见 CLAUDE.md「Build / Lint / Test」一节。

---

## 六、来源列表

| 论断 | 来源 |
|---|---|
| Neovide 无图片渲染能力（features 仅 emoji 回退） | https://neovide.dev/features.html |
| KGP 支持请求及维护者表态 | https://github.com/neovide/neovide/issues/2088 |
| Neovide 图片渲染 draft PR（依赖上游） | https://github.com/neovide/neovide/pull/3039 |
| 上游 vim.img API PR 已关闭未合并 | https://github.com/neovim/neovim/pull/31399 |
| `vim.ui.img` 对 GUI（Neovide）不可用的原因 | https://github.com/neovim/neovim/issues/39434 |
| image.nvim 后端/依赖 | https://github.com/3rd/image.nvim |
| image.nvim 作者：不支持 Neovide | https://github.com/3rd/image.nvim/issues/90 |
| snacks.image 终端支持/依赖/功能/hover | https://github.com/folke/snacks.nvim/blob/main/docs/image.md |
| hologram.nvim 停止维护（2023-11） | https://github.com/edluffy/hologram.nvim |
| telescope-media-files.nvim 停滞（2024-03）/后端 | https://github.com/nvim-telescope/telescope-media-files.nvim |
| image_preview.nvim 环境支持清单（WSL 未支持） | https://github.com/adelarsq/image_preview.nvim |
| Neovide WSL2 启动类 issue 样例 | #2662 #2227 #2590 #3160 #3083（均见 https://github.com/neovide/neovide/issues/… ） |
| Chafa（ANSI 字符画，GUI 可用的降级方案） | https://hpjansson.org/chafa/ |
