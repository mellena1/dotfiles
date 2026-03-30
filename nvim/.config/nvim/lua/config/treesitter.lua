-- Install parsers
require('nvim-treesitter').install({
	"c",
	"lua",
	"vim",
	"vimdoc",
	"query",
	"elixir",
	"heex",
	"javascript",
	"typescript",
	"tsx",
	"html",
	"markdown",
	"markdown_inline",
	"rust",
	"go",
	"gomod",
	"gosum",
	"gotmpl",
	"json",
	"terraform",
	"yaml",
	"java",
	"kotlin",
	"zig",
	"graphql",
})

-- Enable highlighting for all filetypes
vim.api.nvim_create_autocmd('FileType', {
	pattern = '*',
	callback = function()
		pcall(vim.treesitter.start)
	end,
})

-- Enable treesitter-based indentation (experimental)
vim.api.nvim_create_autocmd('FileType', {
	pattern = '*',
	callback = function()
		vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
	end,
})
