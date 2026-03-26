require("conform").setup({
	formatters_by_ft = {
		lua = { "stylua" },
		python = { "ruff_format", "ruff_organize_imports" },
		rust = { lsp_format = "prefer" },
		javascript = { "prettier" },
		javascriptreact = { "prettier" },
		typescript = { "prettier" },
		typescriptreact = { "prettier" },
		kotlin = { "spotless_gradle", lsp_format = "never" },
		java = { "spotless_gradle", lsp_format = "never" },
		graphql = { "prettier" },
		json = { "prettier" },
		yaml = { "prettier" },
		markdown = { "prettier" },
		toml = { "taplo" },
		sh = { "shfmt" },
		bash = { "shfmt" },
		html = { "prettier" },
		css = { "prettier" },
		scss = { "prettier" },
		go = { lsp_format = "prefer" },
		sql = { "sqlfluff" },
	},
	format_on_save = function(bufnr)
		-- Disable auto-format for Java/Kotlin since spotless is so slow
		if vim.bo[bufnr].filetype == "java" or vim.bo[bufnr].filetype == "kotlin" then
			return
		end
		return {
			timeout_ms = 2000,
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
