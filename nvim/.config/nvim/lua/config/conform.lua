require("conform").setup({
	formatters_by_ft = {
		lua = { "stylua" },
		-- Conform will run multiple formatters sequentially
		python = { "isort", "black" },
		-- You can customize some of the format options for the filetype (:help conform.format)
		rust = { "rustfmt", lsp_format = "fallback" },
		-- Conform will run the first available formatter
		javascript = { "prettierd", "prettier", stop_after_first = true },
		kotlin = { "spotless_gradle" }
	},
	format_on_save = {
		-- Need to have long timeout because spotless is so slow :(
		timeout_ms = 10000,
		lsp_format = "fallback",
	},
})
