vim.opt.number = true
vim.opt.relativenumber = true

vim.keymap.set('n', '<M-CR>', vim.lsp.buf.code_action, { desc = 'Apply LSP code action' })
