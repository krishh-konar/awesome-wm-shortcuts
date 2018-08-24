-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
require("vicious")

local hotkeys_popup = require("awful.hotkeys_popup").widget
local revelation=require("revelation")
-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")


-- Custom Widgets
local battery_widget = require("awesome-wm-widgets.battery-widget.battery")
local cpu_widget = require("awesome-wm-widgets.cpu-widget.cpu-widget")
local volumearc_widget = require("awesome-wm-widgets.volumearc-widget.volumearc")
local volume_widget = require("awesome-wm-widgets.volume-widget.volume")
local weather_widget = require("awesome-wm-widgets.weather-widget.weather")


-----------------------------------------------------------------------------
-- {{{ Error handling
------------------------------------------------------------------------------
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
   naughty.notify({ preset = naughty.config.presets.critical,
   		    title = "Oops, there were errors during startup!",
		    text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
	local in_error = false
	awesome.connect_signal("debug::error", function (err)
		-- Make sure we don't go into an endless error loop
		if in_error then return end
		in_error = true

		naughty.notify({ preset = naughty.config.presets.critical,
				 title = "Oops, an error happened!",
				 text = tostring(err) })
		in_error = false
	end)
end
-- }}}
-----------------------------------------------------------------------------
-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
-----------------------------------------------------------------------------
--
--
--

--beautiful.init(gears.filesystem.get_themes_dir() .. "default/theme.lua")
beautiful.init(awful.util.getdir("config") .. "/themes/blueres/theme.lua")

revelation.init()

-- This is used later as the default terminal and editor to run.
terminal = "x-terminal-emulator"
editor = os.getenv("EDITOR") or "vim"
editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-----------------------------------------------------------------------------
-- Autostart
-----------------------------------------------------------------------------
awful.spawn.with_shell("~/.config/awesome/autorun.sh")

--------------------------------------------------------------------------------
-- Table of layouts to cover with awful.layout.inc, order matters.
--------------------------------------------------------------------------------
awful.layout.layouts = {
   awful.layout.suit.floating,
   awful.layout.suit.tile,
   awful.layout.suit.fair,
-- awful.layout.suit.tile.left,
   awful.layout.suit.tile.bottom,
-- awful.layout.suit.tile.top,
-- awful.layout.suit.fair.horizontal,
   awful.layout.suit.spiral,
-- awful.layout.suit.spiral.dwindle,
-- awful.layout.suit.max,
-- awful.layout.suit.max.fullscreen,
-- awful.layout.suit.magnifier,
-- awful.layout.suit.corner.nw,
-- awful.layout.suit.corner.ne,
-- awful.layout.suit.corner.sw,
-- awful.layout.suit.corner.se,
}
-- }}}

--------------------------------------------------------------------------------
-- {{{ Helper functions
--------------------------------------------------------------------------------
local function client_menu_toggle_fn()
	local instance = nil

	return function ()
		if instance and instance.wibox.visible then
			instance:hide()
			instance = nil
		else
			instance = awful.menu.clients({ theme = { width = 250 } })
		end
	end
end
-- }}}


naughty.config.notify_callback = function(args)
	if args.icon then
		args.icon_size = 100
	end
	return args
end


--------------------------------------------------------------------------------
-- {{{ Menu
--------------------------------------------------------------------------------
-- Create a launcher widget and a main menu
myawesomemenu = {
	{ "hotkeys", function() return false, hotkeys_popup.show_help end},
	{ "manual", terminal .. " -e man awesome" },
	{ "edit config", editor_cmd .. " " .. awesome.conffile },
	{ "restart", awesome.restart },
	{ "quit", function() awesome.quit() end}
}

mymainmenu = awful.menu({ 
	items = { 
		{ "awesome", myawesomemenu},-- beautiful.awesome_icon },
		{ "open terminal", terminal },
		{ "Shutdown", function() awesome.spawn("systemctl poweroff") end }, 
		{ "Reboot", function() awesome.spawn("systemctl reboot") end } 
	}
})

mylauncher = wibox.layout.margin(awful.widget.launcher({ image = beautiful.awesome_icon, menu = mymainmenu }), 0,2,9,9)

--------------------------------------------------------------------------------
-- Menubar configuration
--------------------------------------------------------------------------------
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- Keyboard map indicator and switcher
mykeyboardlayout = awful.widget.keyboardlayout()

-- {{{ Wibar
-- Create a textclock widget
mytextclock = wibox.widget.textclock(" %a %d, %H:%M:%S ", 1 )
local cal_notification
mytextclock:connect_signal("button::release",
    function()
        if cal_notification == nil then
            awful.spawn.easy_async([[bash -c "ncal -3C | sed 's/_.\(.\)/+\1-/g'"]],
                function(stdout, stderr, reason, exit_code)
                    cal_notification = naughty.notify{
                        text = string.gsub(string.gsub(stdout, 
                                                       "+", "<span foreground='red'>"), 
                                                       "-", "</span>"),
                        font = "Ubuntu Mono 9",
                        timeout = 0,
                        width = auto,
                        destroy = function() cal_notification = nil end
                    }
                end
            )
        else
            naughty.destroy(cal_notification)
        end
    end)

-- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(
awful.button({ }, 1, function(t) t:view_only() end),
awful.button({ modkey }, 1, function(t)
	if client.focus then
		client.focus:move_to_tag(t)
	end
end),
awful.button({ }, 3, awful.tag.viewtoggle),
awful.button({ modkey }, 3, function(t)
	if client.focus then
		client.focus:toggle_tag(t)
	end
end),
awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
)
--[[
local tasklist_buttons = gears.table.join(
awful.button({ }, 1, function (c)
if c == client.focus then
c.minimized = true
else
-- Without this, the following
-- :isvisible() makes no sense
c.minimized = false
if not c:isvisible() and c.first_tag then
c.first_tag:view_only()
end
-- This will also un-minimize
-- the client, if needed
client.focus = c
c:raise()
end
end),
awful.button({ }, 3, client_menu_toggle_fn()),
awful.button({ }, 4, function ()
awful.client.focus.byidx(1)
end),
awful.button({ }, 5, function ()
awful.client.focus.byidx(-1)
end))
]]
--[[local function set_wallpaper(s)
-- Wallpaper
if beautiful.wallpaper then
local wallpaper = beautiful.wallpaper
-- If wallpaper is a function, call it with the screen
if type(wallpaper) == "function" then
wallpaper = wallpaper(s)
end
gears.wallpaper.maximized(wallpaper, s, true)
end
end

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)
]]
awful.screen.connect_for_each_screen(function(s)
-- Wallpaper
--   set_wallpaper(s)

-- Each screen has its own tag table.
awful.tag({ " ⚔️ ", " ⚔️ ", " ⚔️ ", " ⚔️ ", " ⚔️ ", " ⚔️ ", " ⚔️ " }, s, awful.layout.layouts[2])
beautiful.taglist_spacing = "0"
-- Create a promptbox for each screen
s.mypromptbox = awful.widget.prompt()
-- Create an imagebox widget which will contain an icon indicating which layout we're using.
-- We need one layoutbox per screen.
s.mylayoutbox = wibox.container.margin(awful.widget.layoutbox(s), 8,8,9,9)
s.mylayoutbox:buttons(gears.table.join(
awful.button({ }, 1, function () awful.layout.inc( 1) end),
awful.button({ }, 3, function () awful.layout.inc(-1) end),
awful.button({ }, 4, function () awful.layout.inc( 1) end),
awful.button({ }, 5, function () awful.layout.inc(-1) end)))
-- Create a taglist widget
s.mytaglist = awful.widget.taglist(s, awful.widget.taglist.filter.all, taglist_buttons)


-- Systray
--------------------------------------------------------------------------------
local systray = wibox.layout.margin(wibox.widget.systray(), 0,0,6,5)
beautiful.systray_icon_spacing = 14

-- Separator
--------------------------------------------------------------------------------
local separator = wibox.widget.textbox()
separator.text = " "

-- Checkupdates 
--------------------------------------------------------------------------------
local checkupd = awful.widget.watch('bash -c "checkupdates | wc -l "', 31)
local updicon = wibox.widget.textbox()
--aur.markup = '<span color="#a0a0a0">  </span>'
updicon.text =  ""

local pacman = wibox.widget {
	updicon,
	checkupd,
	layout = wibox.layout.fixed.horizontal,
}
pacman:buttons(awful.button({ }, 1, function () awful.spawn("termite -e 'trizen -Syu'") end))

-- global title bar    ------ holgerschurig.de/en/awesome-4.0-global-titlebar/
-----------------------------------------------------------------------------
local mytitle = wibox.widget {
	markup = " ",
	align = "center",
	font = "Roboto Mono Medium 10",
	widget = wibox.widget.textbox,
}
local function update_title_text(c)
	local s
	if c == client.focus then
		if c.class then
			if c.name then
				s = c.name
			else
				s = c.class
			end
		else
			s = c.name
		end
		if s then
			mytitle.text = s
		end
	end
end
client.connect_signal("focus", update_title_text)
client.connect_signal("property::name", update_title_text)
client.connect_signal("unfocus", function (c) mytitle.markup = " " end)



-- infos from mpris clients such asfour sea spotify and VLC
-- based on https://github.com/acrisci/playerctl
local mpris, mpris_timer = awful.widget.watch(
{ awful.util.shell, "-c", "playerctl status && playerctl metadata" },
7,
function(widget, stdout)
	local escape_f  = require("awful.util").escape
	local mpris_now = {
		state        = "N/A",
		artist       = "N/A",
		title        = "N/A",
		art_url      = "N/A",
		album        = "N/A",
		album_artist = "N/A"
	}

	mpris_now.state = string.match(stdout, "Playing") or
	string.match(stdout, "Paused")  or "N/A"

	for k, v in string.gmatch(stdout, "'[^:]+:([^']+)':[%s]<%[?'([^']+)'%]?>")
		do
			if     k == "artUrl"      then mpris_now.art_url      = v
			elseif k == "artist"      then mpris_now.artist       = escape_f(v)
				elseif k == "title"       then mpris_now.title        = escape_f(v)
				elseif k == "album"       then mpris_now.album        = escape_f(v)
				elseif k == "albumArtist" then mpris_now.album_artist = escape_f(v)
				end
			end

			-- customize here
			if mpris_now.state == "Playing" then widget:set_text(mpris_now.artist .. " - " .. mpris_now.title)
			else
				widget:set_text("")
			end
		end
		)

		local spotify = wibox.widget {
			layout = wibox.container.constraint,
			width = 400,
			{ widget = mpris,   },
		}

-- Create the wibox
s.mywibox = awful.wibar({ position = "top", screen = s })

-- Add widgets to the wibox
s.mywibox:setup {
	layout = wibox.layout.align.horizontal,
	{ -- Left widgets
	layout = wibox.layout.fixed.horizontal,
	separator,
	mylauncher,
	separator,
	--	    separator,
	s.mytaglist,
	s.mypromptbox,
	},
	{ -- Middle widget
	mytitle,
	layout = wibox.container.margin,
	left =  1,
	right = 20,
	},
	{ -- Right widgets
	layout = wibox.layout.fixed.horizontal,
	--mpris,
	spotify,
	separator,
	cpu_widget,
	separator,

	--mykeyboardlayout,
	volume_widget,
	separator,
        battery_widget,
	separator,
	weather_widget,
	separator,	
	systray,
	mytextclock,
	s.mylayoutbox,
	separator,
},
    }
end)
-- }}}
--------------------------------------------------------------------------------
-- {{{ Mouse bindings & Key bindings
--------------------------------------------------------------------------------
root.buttons(gears.table.join(
awful.button({ }, 3, function () mymainmenu:toggle() end)
--    awful.button({ }, 4, awful.tag.viewnext),
--    awful.button({ }, 5, awful.tag.viewprev)
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
awful.key({ modkey,           }, "Tab",      revelation),
awful.key({ modkey,           }, "j",
function ()
	awful.client.focus.byidx( 1)
end,
{description = "focus next by index", group = "client"}
),

-- Custom mappings
awful.key({ }, "#68", function () awful.util.spawn("amixer -D pulse sset Master 5%-") end),
awful.key({ }, "#69", function () awful.util.spawn("amixer -D pulse sset Master 5%+") end),
awful.key({ }, "#67", function () awful.util.spawn("amixer -D pulse sset Master 1+ toggle") end),
awful.key({ }, "#107", function () awful.util.spawn("gnome-screenshot") end),

-- Lock Screen
awful.key({ modkey, "Control" }, "Escape", 
function () 
	awful.util.spawn("xscreensaver-command -lock")
end),

awful.key({ modkey,           }, "k",
function ()
	awful.client.focus.byidx(-1)
end,
{description = "focus previous by index", group = "client"}
),
awful.key({ modkey,           }, "w", function () mymainmenu:show({ coords = { x = 0, y = 0 } }) end,
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
awful.key({ modkey, "Control"           }, "Tab",
function ()
	awful.client.focus.history.previous()
	if client.focus then
		client.focus:raise()
	end
end,
{description = "go back", group = "client"}),

-- Standard program
awful.key({ modkey,           }, ",", function () awful.spawn("playerctl previous")  end,
	  {description = "spotify prev", group = "launcher"}),
awful.key({ modkey,           }, ".", function () awful.spawn("playerctl next")  end,
	  {description = "spotify next", group = "launcher"}),
    awful.key({ modkey,           }, "Return", function () awful.spawn(terminal) end,
              {description = "open a terminal", group = "launcher"}),
awful.key({ modkey,  }, "f", function() awful.spawn("kitty ranger") end,
	  {description = "ranger", group = "launcher"}),
awful.key({ modkey,  }, "Print", function() awful.spawn("i3-scrot") end,
	  {description = "scrot", group = "launcher"}),
awful.key({ modkey,  }, "c", function() awful.spawn("firefox") end,
	  {description = "firefox", group = "launcher"}),
awful.key({ modkey,  }, "d", function() awful.spawn("rofi -show run -display-run 'run' -matching 'fuzzy'") end,
	  {description = "firefox", group = "launcher"}),
awful.key({modkey, }, "q", function() awful.spawn("copyq show") end,
	  {description = 'show clipboard', group = "launcher"}),
awful.key({ modkey, "Control" }, "r", awesome.restart,
	  {description = "reload awesome", group = "awesome"}),
awful.key({ modkey, "Shift"   }, "q", awesome.quit,
	  {description = "quit awesome", group = "awesome"}),

awful.key({modkey, }, "p", function() end),

awful.key({ modkey, "Shift"    }, "Right",     function () awful.tag.incmwfact( 0.01)    end),
awful.key({ modkey, "Shift"    }, "Left",     function () awful.tag.incmwfact(-0.01)    end),
awful.key({ modkey, "Shift"    }, "Down",     function () awful.client.incwfact( 0.01)    end),
awful.key({ modkey, "Shift"    }, "Up",     function () awful.client.incwfact(-0.01)    end),

--awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)          end,
--	  {description = "increase master width factor", group = "layout"}),
--awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)          end,
--	  {description = "decrease master width factor", group = "layout"}),
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
		client.focus = c
		c:raise()
	end
end,
	  {description = "restore minimized", group = "client"}),

-- Prompt
awful.key({ modkey },            "r",     function () awful.screen.focused().mypromptbox:run() end,
	  {description = "run prompt", group = "launcher"}),

awful.key({ modkey, "Shift" }, "x",
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
awful.key({ modkey, "Shift" }, "p", function() menubar.show() end,
	  {description = "show the menubar", group = "launcher"})
)

clientkeys = gears.table.join(
awful.key({ modkey, "Shift"    }, "f",
function (c)
	c.fullscreen = not c.fullscreen
	c:raise()
end,
	  {description = "toggle fullscreen", group = "client"}),
awful.key({ modkey,    }, "x",      function (c) c:kill()                         end,
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
awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
awful.button({ modkey }, 1, awful.mouse.client.move),
awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
	-- All clients will match this rule.
	{ rule = { },
	properties = { border_width = beautiful.border_width,
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
    { rule_any = {
	    instance = {
		    --          "DTA",  -- Firefox addon DownThemAll.
		    "copyq",  -- Includes session name in class.
	    },
	    class = {
		    "Arandr",
		    "Gpick",
		    --          "Kruler",
		    --          "MessageWin",  -- kalarm.
		    --          "Sxiv",
		    "Wpa_gui",
		    "pinentry",
		    --	  "Thunar",
		    "veromix",
		    "xtightvncviewer"},

		    name = {
			    "Event Tester",  -- xev.
		    },
		    role = {
			    "AlarmWindow",  -- Thunderbird's calendar.
			    "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
		    }
	    }, properties = { floating = true, 
	    placement = awful.placement.centered 
    }
     },

     -- Add titlebars to normal clients and dialogs
     { rule_any = {type = { "normal", "dialog" }
      }, properties = { titlebars_enabled = true }
    },

    --[[ remove Firefox border 
    { rule = { class = "Firefox" },
    properties = { border_width = 0 } },]]
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
	-- Set the windows at the slave,
	-- i.e. put it at the end of others instead of setting it master.
	-- if not awesome.startup then awful.client.setslave(c) end

	if awesome.startup and
		not c.size_hints.user_position
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
		client.focus = c
		c:raise()
		awful.mouse.client.move(c)
	end),
	awful.button({ }, 3, function()
		client.focus = c
		c:raise()
		awful.mouse.client.resize(c)
	end)
	)

	awful.titlebar(c) : setup {
		{
		{ -- Left
		--            awful.titlebar.widget.iconwidget(c),
		buttons = buttons,
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
		awful.titlebar.widget.stickybutton   (c),
		awful.titlebar.widget.maximizedbutton(c),
		--awful.titlebar.widget.ontopbutton    (c),
		--awful.titlebar.widget.closebutton    (c),
		awful.titlebar.widget.floatingbutton (c),
		layout = wibox.layout.fixed.horizontal()
	    	},

    	    layout = wibox.layout.align.horizontal
    },
    right = 2,
    widget = wibox.container.margin
}    

-- Hide the titlebar if we are not floating
local l = awful.layout.get(c.screen)
if not (l.name == "floating" or c.floating) then
	awful.titlebar.hide(c)
end

end)

-- smart gaps
local function get_num_tiled(t, s)
	s = s or t.screen
	local num_tiled
	if t == s.selected_tag then
		num_tiled = #awful.client.tiled(s)
	else
		num_tiled = 0
		for _, tc in ipairs(t:clients()) do
			if not tc.floating
				and not tc.fullscreen
				and not tc.maximized_vertical
				and not tc.maximized_horizontal
				then
					num_tiled = num_tiled + 1
				end
			end
		end
		return num_tiled
	end


awful.tag.object.get_gap = function(t)
	t = t or awful.screen.focused().selected_tag
	if get_num_tiled(t) == 1 then
		return  0 
	end
	return awful.tag.getproperty(t, "useless_gap") or beautiful.useless_gap or  0  
end

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
	if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
		and awful.client.focus.filter(c) then
		client.focus = c
	end
end)

client.connect_signal("property::floating", function (c)
	if c.floating then
		awful.titlebar.show(c)
	else
		awful.titlebar.hide(c)
	end
end)


client.connect_signal("property::fullscreen", function(c)
	if c.fullscreen then
		gears.timer.delayed_call(function()
			if c.valid then
				c:geometry(c.screen.geometry)
			end
		end)
	end
end)


-- awesome-copycats smart border
--------------------------------------------------------------------------------

-- No border for maximized clients
function border_adjust(c)
	if c.maximized then -- no borders if only 1 client visible
		c.border_width = 0
	elseif #awful.screen.focused().clients > 1 then
		c.border_width = beautiful.border_width
		c.border_color = beautiful.border_focus
	else
		c.border_width = 0 
	end
end
-- No border for maximized clients
function border_unadjust(c)
	if c.maximized then -- no borders if only 1 client visible
		c.border_width = 0
	elseif #awful.screen.focused().clients > 1 then
		c.border_width = beautiful.border_width
		c.border_color = beautiful.border_normal
	else
		c.border_width = 0 
	end
end

client.connect_signal("focus", border_adjust)
client.connect_signal("property::maximized", border_adjust)
client.connect_signal("unfocus", border_unadjust)
--client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
--client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)

-- round corners
--------------------------------------------------------------------------
--client.connect_signal("manage", function (c, startup) c.shape = function(cr,w,h) gears.shape.rounded_rect(cr,w,h,10) end end)


-- }}}