local capabilities = require('cmp_nvim_lsp').default_capabilities()
require('lsp-format').setup {}
local on_attach = require('lsp-format').on_attach

local lspconfig = require('lspconfig')
local util = lspconfig.util

vim.keymap.set('n', '<M-CR>', vim.lsp.buf.code_action, { desc = 'Apply LSP code action' })
vim.keymap.set('n', '<leader>r', vim.lsp.buf.rename)

lspconfig.gopls.setup {
	capabilities = capabilities,
	on_attach = on_attach,
}

lspconfig.lua_ls.setup {
	capabilities = capabilities,
	on_attach = on_attach,
	settings = {
		Lua = {
			format = {
				enable = true,
				defaultConfig = {
					indent_style = "space",
					indent_size = "2",
				},
			},
		},
	},
}

lspconfig.rust_analyzer.setup {
	capabilities = capabilities,
	on_attach = on_attach,
}

lspconfig.terraformls.setup {
	capabilities = capabilities,
	on_attach = on_attach,
}

lspconfig.ts_ls.setup {
	capabilities = capabilities,
	-- no on_attach here bc we want to format with eslint
}

lspconfig.eslint.setup {
	capabilities = capabilities,
	on_attach = on_attach,
	root_dir = function(fname)
		-- our project root_dir is wherever tsconfig.json lives
		return util.root_pattern('tsconfig.json')(fname)
	end,
}

lspconfig.pylsp.setup {}

vim.lsp.enable("kotlin_lsp")
