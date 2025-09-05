local monokai = require('monokai')
local palette = monokai.classic

monokai.setup {
	custom_hlgroups = {
		Normal = {
			bg = palette.black
		},
		Cursor = {
			bg = palette.orange,
		},
		iCursor = {
			bg = palette.orange
		},
		LineNr = {
			bg = palette.black
		}
	}
}
