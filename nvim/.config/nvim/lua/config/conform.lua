require("conform").setup({
	formatters_by_ft = {
		lua = { "stylua" },
		python = { "ruff_format", "ruff_organize_imports" },
		rust = { lsp_format = "prefer" },
		javascript = { "prettierd", "prettier", stop_after_first = true },
		javascriptreact = { "prettierd", "prettier", stop_after_first = true },
		typescript = { "prettierd", "prettier", stop_after_first = true },
		typescriptreact = { "prettierd", "prettier", stop_after_first = true },
		kotlin = { "spotless_gradle", lsp_format = "never" },
		java = { "spotless_gradle", lsp_format = "never" },
		graphql = { "prettierd" },
		json = { "prettierd", "prettier", stop_after_first = true },
		yaml = { "prettierd", "prettier", stop_after_first = true },
		markdown = { "prettierd", "prettier", stop_after_first = true },
		toml = { "taplo" },
		sh = { "shfmt" },
		bash = { "shfmt" },
		html = { "prettierd", "prettier", stop_after_first = true },
		css = { "prettierd", "prettier", stop_after_first = true },
		scss = { "prettierd", "prettier", stop_after_first = true },
		go = { lsp_format = "prefer" },
		sql = { "sqlfluff" },
	},
	format_on_save = function(bufnr)
		-- Disable auto-format for Java/Kotlin since spotless is so slow
		if vim.bo[bufnr].filetype == "java" or vim.bo[bufnr].filetype == "kotlin" then
			return
		end
		return {
			timeout_ms = 500,
			lsp_format = "fallback",
		}
	end,
})

-- Manual format keybind (useful for slow formatters like spotless)
vim.keymap.set({ "n", "v" }, "<leader>f", function()
	require("conform").format({
		async = false,
		timeout_ms = 30000, -- 30 seconds for spotless
		lsp_format = "fallback",
	})
end, { desc = "Format buffer" })
