local monokai = require('monokai')
local palette = monokai.classic

monokai.setup {
	custom_hlgroups = {
		Normal = {
			bg = palette.black
		},
		LineNr = {
			bg = palette.black
		}
	}
}
