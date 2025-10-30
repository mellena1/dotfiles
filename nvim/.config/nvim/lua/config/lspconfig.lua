local capabilities = require('cmp_nvim_lsp').default_capabilities()

vim.keymap.set('n', '<M-CR>', vim.lsp.buf.code_action, { desc = 'Apply LSP code action' })
vim.keymap.set('n', '<leader>r', vim.lsp.buf.rename)

vim.lsp.config('*', {
	capabilities = capabilities,
})

vim.lsp.config('eslint', {
	root_dir = function(fname)
		-- our project root_dir is wherever tsconfig.json lives
		return vim.fs.root(fname, 'tsconfig.json')
	end,
})

-- Enable all servers
vim.lsp.enable('gopls')
vim.lsp.enable('lua_ls')
vim.lsp.enable('rust_analyzer')
vim.lsp.enable('terraformls')
vim.lsp.enable('ts_ls')
vim.lsp.enable('eslint')
vim.lsp.enable('pylsp')
vim.lsp.enable('kotlin_lsp')
vim.lsp.enable('zls')
