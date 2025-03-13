local capabilities = require('cmp_nvim_lsp').default_capabilities()
require('lsp-format').setup {}
local on_attach = require('lsp-format').on_attach

local lspconfig = require('lspconfig')

lspconfig.gopls.setup {}

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
