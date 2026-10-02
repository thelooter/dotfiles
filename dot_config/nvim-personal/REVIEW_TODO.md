# Neovim config — outstanding review items

Carry-over from a config review (2026-06-01). The icon/Nerd-Font-v3 work and a
batch of quick fixes are **already done** (see "Already fixed" at the bottom for
context). Everything below is **still open**.

Paths are relative to the chezmoi source dir
`dot_config/nvim-personal/` (apply with `chezmoi apply`).

---

## 🔴 Behavioral / likely-broken

### 1. Treesitter — ✅ DONE (migrated to `main`-branch API)
Resolved 2026-06-01. Context: `nvim-treesitter/nvim-treesitter` was archived
(read-only) on 2026-04-03 after the 0.12 rewrite. We stayed on the original repo
(frozen but stable) and took option (b):
- `lua/config/treesitter.lua` rewritten to the `main` API:
  `require('nvim-treesitter').setup()` + `.install(<explicit parser list>)`
  (no more `ensure_installed = "all"` on `main`), highlight via a `FileType`
  autocmd calling `vim.treesitter.start()`, indent via the experimental
  `nvim-treesitter.indentexpr()`.
- `lua/plugins.lua`: TS spec set to `lazy = false` (the `main` branch does **not**
  support lazy-loading) and dropped the `event = "BufRead"` trigger.
- `after/plugin/defaults.lua:53` → `opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"`.
- Removed `RRethy/nvim-treesitter-endwise` (a master-branch *module*; the module
  system is gone on `main`). endwise-lua still covered by nvim-autopairs.
- **Behavior dropped:** incremental-selection (was a TS module, no `main`/core
  equivalent).
- **Textobjects re-added** on its `main` branch (`nvim-treesitter-textobjects`):
  select (`af`/`if`/`ac`/`ic`), parameter swap (`<leader>rx`/`<leader>rX`),
  function/class motions (`]m`/`[m`/`]]`/`[[` + capitals), and repeatable moves
  (`;`/`,`). `lsp_interop`/peek was removed in the rewrite, so the old
  `<leader>df`/`<leader>dF` peek maps are gone.
- Run `:TSUpdate` once after `chezmoi apply` to (re)build parsers for `main`.

### 2. Dead `ts-utils` branch (server rename)
- `lua/config/lsp/init.lua:165` checks `client.name == "tsserver"`, but the server
  is configured as `ts_ls` (the post-rename name) → the branch never runs.
- Note `jose-elias-alvarez/nvim-lsp-ts-utils` is archived; consider dropping it
  and its `<leader>c` typescript keymaps that depend on `TSLsp*` commands.

### 3. Dead keymap: `<leader>oo → DevdocsOpen`
- `lua/config/which-key-new.lua` maps `DevdocsOpen`, but no devdocs plugin is
  installed → command doesn't exist. Remove or install a devdocs plugin.

---

## 🟡 Dead files & dead code (investigate before deleting — user wants to check why disabled)

### 4. Orphaned `lua/config/*.lua` files (never `require`d anywhere)
`alpha.lua`, `colors.lua`, `copilot.lua`, `coq.lua`, `legendary.lua`,
`luasnip.lua` (superseded by `config.snip`), `neogit.lua`, `test.lua`,
`whichkey.lua` (superseded by `which-key-new.lua`), `winbar.lua`.
- `alpha.lua` is the alpha-vim dashboard; you use `dashboard-nvim` instead. Its
  glyphs were repaired during the icon pass, but the file is still unloaded.

### 5. `which-key-new.lua` dead code
- Lines ~42–174 build old which-key-v2 spec tables (`keymaps_f`, `keymaps_p`,
  `mappings`) that are **never registered** — only the `entries` array (new
  `whichkey.add()` syntax) is used.
- `keymaps_f` is also assigned twice (Telescope version then FzfLua version); the
  first is dead before use.

### 6. `after/plugin/autocmds.lua` cleanups
- Legacy `if not has_0_7` Vimscript branch is unreachable (on 0.12).
- `print("DEBUG: ...")` statements spam `:messages` on every startup and every
  `LazySync`/`LazyUpdate` — gate behind a debug flag or remove.
- `YankHighlight` augroup is defined **twice** (here and in
  `after/plugin/defaults.lua:26-31`) — keep one.

### 7. Comment.nvim — currently `enabled = false`
- Left in `lua/plugins.lua` for reference; native `gc`/`gcc` (Neovim 0.10+)
  handles commenting. Consider removing the spec entirely once confirmed happy.

---

## 🟠 Redundant / overlapping plugins (pick one each)

### 8. Two file explorers
- `nvim-tree` + `neo-tree`. All keymaps (`<C-n>`, `<leader>fe`) use `Neotree`;
  `nvim-tree` config is otherwise unreferenced → likely drop `nvim-tree`.

### 9. Two fuzzy finders
- `telescope` + `fzf-lua`, mixed across keymaps (`<leader>fb/fo/fg` use FzfLua;
  others use Telescope). Consolidate to reduce maintenance.

### 10. Two debuggers
- `nvim-dap` (full per-language config under `lua/config/dap/`) + `vimspector`.
  Both heavy. Pick one.

---

## 🔵 Startup performance (lazy-loading)

### 11. Eagerly-loaded plugins (no `event`/`ft`/`cmd`/`keys`)
`octo.nvim`, `nvim-spectre`, `presence.nvim`, `silicon.nvim`, `pantran.nvim`,
`neo-tree`, `nvim-navic`. Plus explicit `lazy = false`: `flutter-tools` (loads
even for non-Dart), `vimtex` (only needed for `.tex`), `wakatime`.
- Add `cmd`/`ft`/`event = "VeryLazy"` triggers. Run `:Lazy profile` to confirm
  the worst offenders.

### 12. Deprecation
- `lua/plugins.lua` uses `vim.loop.fs_stat`; `vim.loop` is deprecated in favor of
  `vim.uv`.

---

## ✅ Already fixed (context — do not redo)
- `lualine.lua` broken `require("config.lsp.null-ls.hover")` → `hovers`
- gitsigns now wired (`config` calling `require("config.gitsigns").setup()`)
- Comment.nvim disabled (`enabled = false`); native `gc`/`gcc` in use
- `<leader>z` "Packer" keymaps → `Lazy` commands
- 16 Nerd Font icon codepoints migrated to v3-stable Codicons across
  `handlers.lua`, `cmp.lua`, `outline.lua`, `dap/init.lua`, `alpha.lua`
  (verified against the installed JetBrainsMono Nerd Font cmap)
