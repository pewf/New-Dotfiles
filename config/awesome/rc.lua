
--[[

	Guillermo's Awesome WM Config File

]]

-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- Standard awesome library
local awful = require("awful")
local gears = require("gears")
local lain = require("lain")
local freedesktop   = require("freedesktop")
local wibox = require("wibox")
local beautiful = require("beautiful")
local naughty = require("naughty")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")

-- // Config File
local config = require('config')

require("awful.autofocus")

local markup = lain.util.markup

require("awful.hotkeys_popup.keys")

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then

	naughty.notify(
		{ 

			preset = naughty.config.presets.critical,     
			title = "Oops, there were errors during startup!",
			text = awesome.startup_errors
	
		}
	)

end

-- Handle runtime errors after startup
do

	local in_error = false

	awesome.connect_signal("debug::error", function (err)

		if in_error then return end

		in_error = true

		naughty.notify(
			{
				preset = naughty.config.presets.critical,
				title = "Oops, an error happened!",
				text = tostring(err)
			}
		)
		in_error = false

	end)

end


-- // Theme
beautiful.init(awful.util.getdir("config") .. "/themes/main/theme.lua")

-- // Autorun
awful.spawn.with_shell("~/.config/awesome/autorun.sh")

awful.spawn.with_shell("picom")
-- awful.spawn.with_shell("nm-applet")

-- // Configuration
modkey = "Mod1"
terminal = "urxvt"
editor = "nano"
editor_cmd = terminal .. " -e " .. editor

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts =
{

    awful.layout.suit.floating,
    awful.layout.suit.tile,
    -- awful.layout.suit.tile.left,
    -- awful.layout.suit.tile.bottom,
    -- awful.layout.suit.tile.top,
    -- awful.layout.suit.fair,
    -- awful.layout.suit.fair.horizontal,
    -- awful.layout.suit.spiral,
    -- awful.layout.suit.spiral.dwindle,
    -- awful.layout.suit.max,
    -- awful.layout.suit.max.fullscreen,
    -- awful.layout.suit.magnifier,
    -- awful.layout.suit.corner.nw,
    -- awful.layout.suit.corner.ne,
    -- awful.layout.suit.corner.sw,
    -- awful.layout.suit.corner.se
    
}

-- // Context Menu
menu = awful.menu(
	{
		items =
		{
			{
				"Terminal",
				terminal
			},
			{
				"File Manager",
				"thunar"
			},
			{
				"Internet",
				{
					{
						"Google Chrome",
						"google-chrome-stable"
					}
				},
			},
			{
				"Utilities",
				{
					{
						"VM Manager",
						"virtual-machine-manager"
					},
					{
						"VirtualBox",
						"virtualbox"
					}
				},
			},
			{
				"Settings",
				{
					{
						"Display",
						"arandr"
					},
					{
						"Appearance",
						"lxappearance"
					}
				},
			},
			{
				"System",
				{
					{
						"Restart",
						awesome.restart
					},
					{
						"Reboot",
						"reboot"
					},
					{
						"Shutdown",
						"shutoff"
					},
					{
						"Log out",
						function() awesome.quit() end
					}
				}
			}
		}
	}
)

-- // Context Menu Configuration
menubar.utils.terminal = terminal


launcher = awful.widget.launcher(
	{
		image = beautiful.awesome_icon,
		menu = menu
	}
)

keyboard_layout = awful.widget.keyboardlayout()
textclock = wibox.widget.textclock(markup("#FFFFFF", "%A, %d %B - %I:%M" .. markup.font("Roboto Condensed Regular 4", "")))

local bat = lain.widget.bat(
{
	
		settings = function()
	
			bat_header = ""
			bat_p      = bat_now.perc .. "% "
	
			widget:set_markup(markup.font("Roboto Condensed Regular 9", markup("#FFFFFF", bat_p)))
	
		end
	
	}
)


-- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(
	awful.button(
		{
		},
		1,
		function(t)
			t:view_only()
		end
	),
	awful.button(
		{
			modkey
		},
		1,
		function(t)
			if client.focus then
				client.focus:move_to_tag(t)
			end
		end
	),
	awful.button(
		{
		}, 
		3,
		awful.tag.viewtoggle
	),
	awful.button(
		{
			modkey
		},
		3,
		function(t)
			if client.focus then
				client.focus:toggle_tag(t)
			end
		end
	),
	awful.button(
		{
		
		},
		4,
		function(t)
			awful.tag.viewnext(t.screen)
		end
	),
	awful.button(
		{
	
		},
		5,
		function(t)
			awful.tag.viewprev(t.screen) 
		end
	)
)

local tasklist_buttons = gears.table.join(
awful.button({ }, 1, function (c)
if c == client.focus then
c.minimized = true
else
c:emit_signal(
"request::activate",
"tasklist",
{raise = true}
)
end
end),
awful.button({ }, 3, function()
awful.menu.client_list({ theme = { width = 250 } })
end),
awful.button({ }, 4, function ()
awful.client.focus.byidx(1)
end),
awful.button({ }, 5, function ()
awful.client.focus.byidx(-1)
end))

local function set_wallpaper(screen)
    
    if beautiful.wallpaper then
    
        local wallpaper = beautiful.wallpaper
        
        if type(wallpaper) == "function" then wallpaper = wallpaper(screen) end
        
        gears.wallpaper.maximized(wallpaper, screen, true)
    
    end
    
end

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

awful.screen.connect_for_each_screen(function(screen)

	set_wallpaper(screen)

	table.insert(config.screens, screen)
	config.taglist.tags[screen] = {}
	
	for tag, name in ipairs(config.taglist.names) do
		config.taglist.tags[screen][tag] = awful.tag.add(name,
			{
				--icon = taglist.icons.idle,
				layout    =  config.taglist.layouts[tag],
				selected  =  config.taglist.selected[tag],
				screen    =  screen
			}
		)
	end


	-- Create an imagebox widget which will contain an icon indicating which layout we're using.
	-- We need one layoutbox per screen.
	
	screen.mylayoutbox = awful.widget.layoutbox(screen)
	
	
	screen.mylayoutbox:buttons(
	
		gears.table.join(
		
			awful.button(
				{}, 
				1,
				function()
					awful.layout.inc(1)
				end
			),
			
			awful.button(
				{},
				3,
				function()
					awful.layout.inc(-1)
				end
			),
			
			awful.button(
				{},
				4,
				function()
					awful.layout.inc(1)
				end
			),
			
			awful.button(
				{},
				5,
				function()
					awful.layout.inc(-1)
				end
			)
			
		)
		
	)
	
	screen.index_count = 1
	
	-- Create a taglist widget
	screen.taglist = awful.widget.taglist
	{
		screen  = screen,
		filter  = awful.widget.taglist.filter.all,
		
		-- // Widget Template
		--[[
		widget_template =
		{
		
			{
				{
					-- // Tag Icon Widget
					id = "tag_icon", --.. tostring(screen.index_count),
				
					-- // Image
					image = taglist.icons.idle,
				
					-- // Image Size
					forced_width = 15,
					forced_height = 15,
				
					widget = wibox.widget.imagebox(taglist.icons.idle),
				},
				
				-- // Vertical Align Placement Widget
				
				id = "tag_container",
				
				halign = "center",
				valign = "center",
				
				widget = wibox.container.place
			},
			
			-- // Set Tag Icon Margin
			
			id = "tag_margin",
			
			left = 1.5,
			right = 1.5,
			
			widget = wibox.container.margin,
			
			
			-- // Callbacks
			
			create_callback = function(self, tag, index, tags)
			
				--if index ~= self.true_index then return end
			
				screen.index_count = screen.index_count + 1
		
				
			
				taglist.tags[screen][index]:connect_signal('property::selected', function(t)
					
					if true then
					
						--[[
						local format = ""
						
						for i, v in pairs(self:get_children_by_id('tag_icon' .. index)[1]) do
							format = format .. "\n" .. tostring(i) .. " - " tostring(v)
						end
						
						naughty.notify({
							preset = naughty.config.presets.critical,
							title = "print",
							text = format
						})
					
						self:get_children_by_id('tag_icon')[1].image = taglist.icons.active
						return
					
					end
					
					if t.selected ~= tag.selected then return end
				
					naughty.notify({
						preset = naughty.config.presets.critical,
						title = "print",
						text = tostring(index) .. " - " .. tostring(tag.selected)
					})
					
					if tag.selected == true then
						self:get_children_by_id('tag_icon')[1].image = taglist.icons.active
						return
					end
					if tag.selected == false then
						self:get_children_by_id('tag_icon')[1].image = taglist.icons.idle
						return
					end
					
				end)
			end,
			update_callback = function(self, tag, index, objects)
				
			end
		},]]
		
		buttons = taglist_buttons,
	}

	-- Create a tasklist widget
	screen.tasklist = awful.widget.tasklist
	{
		screen  = screen,
		filter  = awful.widget.tasklist.filter.currenttags,
		buttons = tasklist_buttons

	}

	--[[ --- Awesome WM Panel ---
	
	-- Create the wibox
	
	screen.mywibox = awful.wibar(
		{
			position = "top",
			screen = screen 
		}
	)

	-- Add widgets to the wibox
	
	screen.mywibox:setup {
		layout = wibox.layout.stack,
		{
			layout = wibox.layout.align.horizontal,
			{ -- Left widgets
				layout = wibox.layout.fixed.horizontal,
				screen.taglist,
				screen.mylayoutbox,
				screen.mypromptbox,
			},
			nil, -- Middle widget
			{ -- Right widgets
				layout = wibox.layout.fixed.horizontal,
				wibox.widget.systray(),
				bat
			}
		},
		{
			textclock,
			valign = "center",
			halign = "center",
			layout = wibox.container.place
		}
	}]]
	
end)

-- {{{ Mouse bindings
root.buttons(gears.table.join(
    awful.button({ }, 3, function () menu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = gears.table.join(
    awful.key({ modkey,           }, "s",      hotkeys_popup.show_help,
              {description="show help", group="awesome"}),
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev,
              {description = "view previous", group = "tag"}),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext,
              {description = "view next", group = "tag"}),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore,
              {description = "go back", group = "tag"}),

    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
        end,
        {description = "focus next by index", group = "client"}
    ),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
        end,
        {description = "focus previous by index", group = "client"}
    ),
    awful.key({ modkey,           }, "w", function () menu:show() end,
              {description = "show main menu", group = "awesome"}),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end,
              {description = "swap with next client by index", group = "client"}),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end,
              {description = "swap with previous client by index", group = "client"}),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end,
              {description = "focus the next screen", group = "screen"}),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end,
              {description = "focus the previous screen", group = "screen"}),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto,
              {description = "jump to urgent client", group = "client"}),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end,
        {description = "go back", group = "client"}),

    -- Standard program
    awful.key({ modkey,           }, "Return", function () awful.spawn(terminal) end,
              {description = "open a terminal", group = "launcher"}),
    awful.key({ modkey, "Control" }, "r", awesome.restart,
              {description = "reload awesome", group = "awesome"}),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit,
              {description = "quit awesome", group = "awesome"}),

    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)          end,
              {description = "increase master width factor", group = "layout"}),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)          end,
              {description = "decrease master width factor", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1, nil, true) end,
              {description = "increase the number of master clients", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1, nil, true) end,
              {description = "decrease the number of master clients", group = "layout"}),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1, nil, true)    end,
              {description = "increase the number of columns", group = "layout"}),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1, nil, true)    end,
              {description = "decrease the number of columns", group = "layout"}),
    awful.key({ modkey,           }, "space", function () awful.layout.inc( 1)                end,
              {description = "select next", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(-1)                end,
              {description = "select previous", group = "layout"}),

    awful.key({ modkey, "Control" }, "n",
              function ()
                  local c = awful.client.restore()
                  -- Focus restored client
                  if c then
                    c:emit_signal(
                        "request::activate", "key.unminimize", {raise = true}
                    )
                  end
              end,
              {description = "restore minimized", group = "client"}),

    -- // Rofi Drun
    awful.key(
	{
		
	},
	"Mod4",
	function()
		awful.spawn.with_line_callback('rofi -show drun', {})
	end,
	{
		description = "run prompt",
		group = "launcher"
	}
    ),

    awful.key({ modkey }, "x",
              function ()
                  awful.prompt.run {
                    prompt       = "Run Lua code: ",
                    textbox      = awful.screen.focused().mypromptbox.widget,
                    exe_callback = awful.util.eval,
                    history_path = awful.util.get_cache_dir() .. "/history_eval"
                  }
              end,
              {description = "lua execute prompt", group = "awesome"}),
    -- Menubar
    awful.key({ modkey }, "p", function() menubar.show() end,
              {description = "show the menubar", group = "launcher"})
)

clientkeys = gears.table.join(
    awful.key({ modkey,           }, "f",
        function (c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        {description = "toggle fullscreen", group = "client"}),
    awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end,
              {description = "close", group = "client"}),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ,
              {description = "toggle floating", group = "client"}),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end,
              {description = "move to master", group = "client"}),
    awful.key({ modkey,           }, "o",      function (c) c:move_to_screen()               end,
              {description = "move to screen", group = "client"}),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end,
              {description = "toggle keep on top", group = "client"}),
    awful.key({ modkey,           }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end ,
        {description = "minimize", group = "client"}),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized = not c.maximized
            c:raise()
        end ,
        {description = "(un)maximize", group = "client"}),
    awful.key({ modkey, "Control" }, "m",
        function (c)
            c.maximized_vertical = not c.maximized_vertical
            c:raise()
        end ,
        {description = "(un)maximize vertically", group = "client"}),
    awful.key({ modkey, "Shift"   }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c:raise()
        end ,
        {description = "(un)maximize horizontally", group = "client"})
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    globalkeys = gears.table.join(globalkeys,
        -- View tag only.
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = awful.screen.focused()
                        local tag = screen.tags[i]
                        if tag then
                           tag:view_only()
                        end
                  end,
                  {description = "view tag #"..i, group = "tag"}),
        -- Toggle tag display.
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = awful.screen.focused()
                      local tag = screen.tags[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end,
                  {description = "toggle tag #" .. i, group = "tag"}),
        -- Move client to tag.
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:move_to_tag(tag)
                          end
                     end
                  end,
                  {description = "move focused client to tag #"..i, group = "tag"}),
        -- Toggle tag on focused client.
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:toggle_tag(tag)
                          end
                      end
                  end,
                  {description = "toggle focused client on tag #" .. i, group = "tag"})
    )
end

clientbuttons = gears.table.join(
    awful.button({ }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
    end),
    awful.button({ modkey }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.move(c)
    end),
    awful.button({ modkey }, 3, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.resize(c)
    end)
)

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules =
{
	{
		rule = {},
      		properties =
		{
			border_width = beautiful.border_width,
			border_color = beautiful.border_normal,
			focus = awful.client.focus.filter,
			raise = true,
			keys = clientkeys,
			buttons = clientbuttons,
			screen = awful.screen.preferred,
			placement = awful.placement.no_overlap+awful.placement.no_offscreen
		}
	},

	-- Floating clients.
	{
	rule_any =
		{
			instance =
			{
				"DTA",  -- Firefox addon DownThemAll.
				"copyq",  -- Includes session name in class.
				"pinentry",
			},
			class =
			{
				"Arandr",
				"Blueman-manager",
				"Gpick",
				"Kruler",
				"MessageWin",  -- kalarm.
				"Sxiv",
				"Tor Browser", -- Needs a fixed window size to avoid fingerprinting by screen size.
				"Wpa_gui",
				"veromix",
				"xtightvncviewer"
			},

			-- Note that the name property shown in xprop might be set slightly after creation of the client
			-- and the name shown there might not match defined rules here.
			name =
			{
				"Event Tester",  -- xev.
			},
			role =
			{
				"AlarmWindow",  -- Thunderbird's calendar.
				"ConfigManager",  -- Thunderbird's about:config.
				"pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
			}
		},
		properties =
		{
			floating = true 
		}
	},

    -- // Enable titlebars and patch alignment isssues
	{
		rule_any =
		{
			type =
			{
				"normal",
				"dialog"
			}
		}, 
		properties =
		{
			size_hints_honor = false,
			titlebars_enabled = false
		}
	},
	
	-- // Titlebar filters
	{
		rule_any =
		{
			instance =
			{
				terminal
			}
		},
		properties =
		{
			titlebars_enabled = false,
		}
	},

	-- // Border filters
	{
		rule_any =
		{
			instance =
			{
				"polybar"
			}
		},
		properties =
		{
			border_width = 0
		}
	},

	-- // Center floating windows
	{
		rule_any =
		{
			--floating = true,
			
			instance =
			{
				terminal
			}
		},
		properties =
		{
		
		},
		callback = function(client)
			awful.placement.centered(client, nil)
		end
	},
	
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end

    if awesome.startup
      and not c.size_hints.user_position
      and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
    -- buttons for the titlebar
    local buttons = gears.table.join(
        awful.button({ }, 1, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.move(c)
        end),
        awful.button({ }, 3, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.resize(c)
        end)
    )

    awful.titlebar(c) : setup {
        { -- Left
            awful.titlebar.widget.closebutton    (c),
            -- awful.titlebar.widget.nminimizedbutton (c),
            awful.titlebar.widget.maximizedbutton(c),
            layout  = wibox.layout.fixed.horizontal
        },
        { -- Middle
            { -- Title
                align  = "center",
                widget = awful.titlebar.widget.titlewidget(c)
            },
            buttons = buttons,
            layout  = wibox.layout.flex.horizontal
        },
        { -- Right
            layout = wibox.layout.fixed.horizontal()
        },
        layout = wibox.layout.align.horizontal
    }
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
    c:emit_signal("request::activate", "mouse_enter",
    	{
    		raise = false
    	}
    )
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)

-- // Handle new floating window placement
client.connect_signal("request::manage", function(client, context)

    if client.floating and context == "new" then
        client.placement = awful.placement.centered
    end
    
end)

-- }}}
