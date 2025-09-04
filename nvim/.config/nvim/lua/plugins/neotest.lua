return {
	{
		"nvim-neotest/neotest",
		branch = "fix/subprocess/load-adapters",
		dependencies = {
			"nvim-neotest/nvim-nio",
			"nvim-lua/plenary.nvim",
			"antoinemadec/FixCursorHold.nvim",
			"nvim-treesitter/nvim-treesitter"
		}
	},
	{
		"rouge8/neotest-rust"
	},
	{
		"nvim-neotest/neotest-go"
	},
	{
		"arthur944/neotest-bun"
	},
	{
		"weilbith/neotest-gradle"
	}
}
