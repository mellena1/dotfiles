-- Truncate the LSP log on startup if it exceeds 100 MB to prevent unbounded growth
vim.api.nvim_create_autocmd("VimEnter", {
	callback = function()
		local log = vim.lsp.log.get_filename()
		local max = 100 * 1024 * 1024 -- 100 MB
		local stat = vim.uv.fs_stat(log)
		if stat and stat.size > max then
			local f = io.open(log, "w")
			if f then f:close() end
		end
	end,
})

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
