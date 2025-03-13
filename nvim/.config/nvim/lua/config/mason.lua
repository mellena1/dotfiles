require("mason").setup()
require("mason-lspconfig").setup {
	ensure_installed = {
		"gopls",
		"lua_ls",
		"rust_analyzer",
		"terraformls",
		"ts_ls",
	},
}
