return {
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		config = function()
			local configs = require("nvim-treesitter.configs")

			configs.setup({
				ensure_installed = {
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
					"json",
					"jsonc",
					"zig",
				},
				sync_install = false,
				highlight = { enable = true },
				indent = { enable = true },
			})
		end
	}
}
