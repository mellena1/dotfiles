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

-- jdtls requires Java 21+ but JAVA_HOME may point to an older JVM
local function find_java_home_gte21()
	if vim.fn.has('mac') == 1 then
		-- -v 21+ returns the highest installed JVM >= 21
		local out = vim.fn.system('/usr/libexec/java_home -v 21+ 2>/dev/null')
		if vim.v.shell_error == 0 then
			return vim.trim(out)
		end
	else
		-- Glob for java-2X+ paths across common Linux layouts, pick highest version
		for _, pattern in ipairs({
			vim.fn.expand('~/.sdkman/candidates/java/2[1-9]*/'),
			vim.fn.expand('~/.sdkman/candidates/java/[3-9][0-9]*/'),
			'/usr/lib/jvm/java-2[1-9]-*',
			'/usr/lib/jvm/temurin-2[1-9]',
		}) do
			local matches = vim.fn.glob(pattern, false, true)
			table.sort(matches, function(a, b) return a > b end)
			for _, dir in ipairs(matches) do
				if vim.uv.fs_stat(dir) then
					return dir
				end
			end
		end
	end
end

local java_home = find_java_home_gte21()
if java_home then
	vim.lsp.config('jdtls', {
		cmd_env = { JAVA_HOME = java_home },
	})
end

-- lua_ls: teach it about vim.* and hyprland hl.* globals
vim.lsp.config('lua_ls', {
	settings = {
		Lua = {
			runtime = { version = 'LuaJIT' },
			diagnostics = {
				globals = { 'vim' },
			},
			workspace = {
				library = {
					vim.env.VIMRUNTIME,
					'/usr/share/hypr/stubs',
				},
				checkThirdParty = false,
			},
			telemetry = { enable = false },
		},
	},
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
	'jdtls',
})
