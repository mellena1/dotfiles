local telescope = require('telescope')
telescope.load_extension('git_branch')

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })

local git_branch = require('git_branch')
vim.keymap.set('n', '<leader>gf', git_branch.files, { desc = 'Telescope find git edited files' })

vim.keymap.set('n', '<leader>fc', builtin.commands, { desc = 'Telescope find commands' })
vim.keymap.set('n', '<leader>fk', builtin.keymaps, { desc = 'Telescope find keymaps' })
vim.keymap.set('n', '<leader>fr', builtin.lsp_references, { desc = 'Telescope find lsp references' })
vim.keymap.set('n', '<leader>fi', builtin.lsp_implementations, { desc = 'Telescope find lsp implementations' })
vim.keymap.set('n', '<leader>fd', builtin.lsp_definitions, { desc = 'Telescope find lsp definitions' })
