local neotest = require("neotest")

neotest.setup({
	adapters = {
		require("neotest-rust") {
			args = { "--no-capture" }
		}
	}
})

vim.keymap.set("n", "<leader>rt", neotest.run.run, { desc = "Run the closest test" })
vim.keymap.set("n", "<leader>ft", function() neotest.run.run(vim.fn.expand("%")) end, { desc = "Run file tests" })
vim.keymap.set("n", "<leader>to", function() neotest.output.open({ enter = true }) end,
	{ desc = "Open test output window" })
