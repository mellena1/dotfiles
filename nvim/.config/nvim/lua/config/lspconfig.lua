local capabilities = require('cmp_nvim_lsp').default_capabilities()

vim.keymap.set('n', '<M-CR>', vim.lsp.buf.code_action, { desc = 'Apply LSP code action' })
vim.keymap.set('n', '<leader>r', vim.lsp.buf.rename)

-- Set default capabilities for all servers
-- lspconfig provides default configs (cmd, filetypes, root_markers) via runtimepath
vim.lsp.config('*', {
	capabilities = capabilities,
})

-- Custom eslint config
vim.lsp.config('eslint', {
	root_dir = function(fname)
		return vim.fs.root(fname, 'tsconfig.json')
	end,
})

-- Enable all servers (lspconfig provides the base config via runtimepath)
vim.lsp.enable({
	'gopls',
	'lua_ls',
	'rust_analyzer',
	'terraformls',
	'ts_ls',
	'eslint',
	'pylsp',
	'kotlin_lsp',
	'zls',
	'graphql',
	'gradle_ls',
})
