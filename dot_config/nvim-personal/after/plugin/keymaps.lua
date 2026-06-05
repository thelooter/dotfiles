local keymap = vim.api.nvim_set_keymap
local default_opts = { noremap = true, silent = true }
local expr_opts = { noremap = true, expr = true, silent = true }

-- Better escape using jk in insert and terminal mode
keymap("i", "jk", "<ESC>", default_opts)
keymap("t", "jk", "<C-\\><C-n>", default_opts)

-- Center search results
keymap("n", "n", "nzz", default_opts)
keymap("n", "N", "Nzz", default_opts)

-- Visual line wraps
keymap("n", "k", "v:count == 0 ? 'gk' : 'k'", expr_opts)
keymap("n", "j", "v:count == 0 ? 'gj' : 'j'", expr_opts)

-- Better indent
keymap("v", "<", "<gv", default_opts)
keymap("v", ">", ">gv", default_opts)

-- Paste over currently selected text without yanking it
keymap("v", "p", '"_dP', default_opts)

-- Switch buffer
keymap("n", "<S-h>", ":bprevious<CR>", default_opts)
keymap("n", "<S-l>", ":bnext<CR>", default_opts)

-- Cancel search highlighting with ESC
keymap("n", "<ESC>", ":nohlsearch<Bar>:echo<CR>", default_opts)

-- Move selected line / block of text in visual mode
keymap("x", "K", ":move '<-2<CR>gv-gv", default_opts)
keymap("x", "J", ":move '>+1<CR>gv-gv", default_opts)

-- Resizing panes
keymap("n", "<Left>", ":vertical resize +1<CR>", default_opts)
keymap("n", "<Right>", ":vertical resize -1<CR>", default_opts)
keymap("n", "<Up>", ":resize -1<CR>", default_opts)
keymap("n", "<Down>", ":resize +1<CR>", default_opts)

keymap("n", "<C-n>", ":Neotree toggle<CR>", default_opts)

keymap("n", "<tab>", ":BufferLineCycleNext <CR>", default_opts)

-- QWERTZ ergonomics: the `[` / `]` motion family sits behind AltGr+8 / AltGr+9
-- on a German layout. Remap the keys in the same *physical* position (the two
-- right of `p`): `ü` -> `[` and `+` -> `]`.
-- These are intentionally REMAPPABLE (remap = true, not noremap) so the whole
-- family keeps resolving through them: textobjects motions (]m/[m, ]]/[[, ...),
-- diagnostics (]d/[d), gitsigns hunks (]c/[c), quickfix (]q/[q), etc. The
-- original `[`/`]` keep working via AltGr; this only adds easier aliases.
-- Trade-off: the builtin `+` (first non-blank of next line) is shadowed.
vim.keymap.set({ "n", "x", "o" }, "ü", "[", { remap = true, silent = true, desc = "[ (QWERTZ position)" })
vim.keymap.set({ "n", "x", "o" }, "+", "]", { remap = true, silent = true, desc = "] (QWERTZ position)" })
