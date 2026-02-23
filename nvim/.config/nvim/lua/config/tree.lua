-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- optionally enable 24-bit colour
vim.opt.termguicolors = true

require("nvim-tree").setup({
	filters = {
		git_ignored = false,
	},
	renderer = {
		group_empty = true,
	},
})
require("lsp-file-operations").setup()

local api = require("nvim-tree.api")

vim.keymap.set('n', '<C-b>', api.tree.toggle, { desc = 'Toggle nvim-tree' })
