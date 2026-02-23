local telescope = require('telescope')

telescope.setup({
	defaults = {
		file_ignore_patterns = { "^.git/", "node_modules/", "%.lock" },
		layout_config = {
			vertical = {
				width = 0.9,
				height = 0.95,
				preview_height = 0.6,
				preview_cutoff = 20,
			},
			horizontal = {
				width = 0.9,
				height = 0.95,
				preview_width = 0.6,
				preview_cutoff = 120,
			},
		},
	},
})

telescope.load_extension('git_branch')

-- Helper function to dynamically choose layout based on screen orientation
local function dynamic_telescope(builtin_func, opts)
	opts = opts or {}
	-- Use vertical layout for narrow screens (like vertical monitors)
	if vim.o.columns < 200 then
		opts.layout_strategy = "vertical"
	else
		opts.layout_strategy = "horizontal"
	end
	builtin_func(opts)
end

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', function()
	dynamic_telescope(builtin.find_files, { hidden = true })
end, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>fg', function() dynamic_telescope(builtin.live_grep) end, { desc = 'Telescope live grep' })
vim.keymap.set('n', '<leader>fb', function() dynamic_telescope(builtin.buffers) end, { desc = 'Telescope buffers' })
vim.keymap.set('n', '<leader>fh', function() dynamic_telescope(builtin.help_tags) end, { desc = 'Telescope help tags' })

local git_branch = require('git_branch')
vim.keymap.set('n', '<leader>gf', function() dynamic_telescope(git_branch.files) end,
	{ desc = 'Telescope find git edited files' })

vim.keymap.set('n', '<leader>fc', function() dynamic_telescope(builtin.commands) end,
	{ desc = 'Telescope find commands' })
vim.keymap.set('n', '<leader>fk', function() dynamic_telescope(builtin.keymaps) end, { desc = 'Telescope find keymaps' })
vim.keymap.set('n', '<leader>fr', function() dynamic_telescope(builtin.lsp_references) end,
	{ desc = 'Telescope find lsp references' })
vim.keymap.set('n', '<leader>fi', function() dynamic_telescope(builtin.lsp_implementations) end,
	{ desc = 'Telescope find lsp implementations' })
vim.keymap.set('n', '<leader>fd', function() dynamic_telescope(builtin.lsp_definitions) end,
	{ desc = 'Telescope find lsp definitions' })
