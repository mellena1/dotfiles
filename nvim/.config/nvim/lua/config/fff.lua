-- Match the 200-column threshold config/telescope.lua uses to pick its layout,
-- so both pickers stack their preview at the same window width.
require('fff').setup({
	layout = {
		flex = { size = 200 },
	},
})

vim.keymap.set('n', '<leader>ff', function() require('fff').find_files() end, { desc = 'FFF find files' })
vim.keymap.set('n', '<leader>fg', function() require('fff').live_grep() end, { desc = 'FFF live grep' })
vim.keymap.set('n', '<leader>fz', function() require('fff').live_grep({ grep = { modes = { 'fuzzy', 'plain' } } }) end,
	{ desc = 'FFF fuzzy grep' })
vim.keymap.set({ 'n', 'x' }, '<leader>fw', function() require('fff').live_grep_under_cursor() end,
	{ desc = 'FFF grep word / selection' })
