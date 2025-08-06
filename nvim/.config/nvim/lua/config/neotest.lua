local neotest = require("neotest")

-- get neotest namespace (api call creates or returns namespace)
local neotest_ns = vim.api.nvim_create_namespace("neotest")
vim.diagnostic.config({
	virtual_text = {
		format = function(diagnostic)
			local message =
			    diagnostic.message:gsub("\n", " "):gsub("\t", " "):gsub("%s+", " "):gsub("^%s+", "")
			return message
		end,
	},
}, neotest_ns)

neotest.setup({
	adapters = {
		require("neotest-rust") {
			args = { "--no-capture" }
		},
		require("neotest-go"),
		require("neotest-bun")
	}
})

vim.keymap.set("n", "<leader>rt", neotest.run.run, { desc = "Run the closest test" })
vim.keymap.set("n", "<leader>ft", function() neotest.run.run(vim.fn.expand("%")) end, { desc = "Run file tests" })
vim.keymap.set("n", "<leader>to", function() neotest.output.open({ enter = true }) end,
	{ desc = "Open test output window" })
