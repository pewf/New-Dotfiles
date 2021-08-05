config = {}

-- // Awesome WM Libraries
local awful = require('awful')
local theme = require('themes/main/theme')

config.screens = {}

config.taglist =
{

	names =
	{
		[1] = "1",
		[2] = "2",
		[3] = "3",
		[4] = "4"
	},
	
	layouts =
	{
		[1] = awful.layout.suit.tile,
		[2] = awful.layout.suit.tile,
		[3] = awful.layout.suit.tile,
		[4] = awful.layout.suit.tile
	},
	
	selected =
	{
		[1] = true,
		[2] = false,
		[3] = false,
		[4] = false
	},
	
	icons =
	{
		idle = theme.workspace.idle,
		active = theme.workspace.active,
		icon_only = 1
	},
	
	tags = {}

}

return config
