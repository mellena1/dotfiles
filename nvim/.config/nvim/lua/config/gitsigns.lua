require('gitsigns').setup {
	on_attach = function(bufnr)
		local gitsigns = require('gitsigns')

		local function map(mode, l, r, opts)
			opts = opts or {}
			opts.buffer = bufnr
			vim.keymap.set(mode, l, r, opts)
		end

		map('n', '<leader>hp', gitsigns.preview_hunk)
		map('n', '<leader>hi', gitsigns.preview_hunk_inline)

		map('n', '<leader>hb', function()
			gitsigns.blame_line({ full = true })
		end)
	end
}
