-------------------------------
--  "Blueres" awesome theme  --
-------------------------------

local awful = require("awful")
local themes_path = awful.util.getdir("config").."/themes/"
local dpi = require("beautiful.xresources").apply_dpi

-- {{{ Main
local theme = {}
theme.wallpaper = nil
-- }}}

-- {{{ Styles
theme.font      = "Roboto Mono Medium 11"

-- {{{ Colors
theme.fg_normal  = "#a0a0a0"
theme.fg_focus   = "#bf6161"
theme.fg_urgent  = "#00aa00"
theme.bg_normal  = "#282c34"
theme.bg_focus   = theme.bg_normal
theme.bg_urgent  = theme.bg_normal
theme.bg_systray = theme.bg_normal
-- }}}

-- {{{ Borders
theme.useless_gap   = dpi(1)
theme.border_width  = dpi(3)
theme.border_normal = "#777777"
theme.border_focus  = theme.bg_normal
theme.border_marked = "#CC9393"
-- }}}

-- {{{ Titlebars
theme.titlebar_bg_focus  = "#e7e8eb"
theme.titlebar_fg_focus  = "#e7e8eb"
theme.titlebar_fg_normal = "#2b303b"
theme.titlebar_bg_normal = "#2b303b"
-- }}}


-- There are other variable sets
-- overriding the default one when
-- defined, the sets are:
-- [taglist|tasklist]_[bg|fg]_[focus|urgent|occupied|empty|volatile]
-- titlebar_[normal|focus]
-- tooltip_[font|opacity|fg_color|bg_color|border_width|border_color]
-- Example:
--theme.taglist_fg_empty = "#555555"

-- {{{ Taglist
theme.taglist_fg_empty = "#555555"
theme.taglist_fg_focus = theme.fg_normal
theme.taglist_bg_focus = "#383f4d"
theme.taglist_fg_occupied = theme.fg_normal
theme.taglist_font = "FontAwesome bold 12"
-- }}}

-- {{{ Widgets
-- You can add as many variables as
-- you wish and access them by using
-- beautiful.variable in your rc.lua
--theme.fg_widget        = "#AECF96"
--theme.fg_center_widget = "#88A175"
--theme.fg_end_widget    = "#FF5656"
--theme.bg_widget        = "#494B4F"
--theme.border_widget    = "#3F3F3F"
-- }}}

-- {{{ Mouse finder
--theme.mouse_finder_color = "#CC9393"
-- mouse_finder_[timeout|animate_timeout|radius|factor]
-- }}}

-- {{{ Menu
-- Variables set for theming the menu:
-- menu_[bg|fg]_[normal|focus]
-- menu_[border_color|border_width]
theme.menu_height = dpi(20)
theme.menu_width  = dpi(150)
theme.menu_border_width = (10)
theme.menu_fg_normal = "#666666"
theme.menu_fg_focus = "#a0a0a0"
theme.menu_border_color = theme.bg_normal
-- }}}

-- {{{ Icons
-- {{{ Taglist
--theme.taglist_squares_sel   = themes_path .. "blueres/taglist/squarefz.png"
--theme.taglist_squares_unsel = themes_path .. "blueres/taglist/squarez.png"
--theme.taglist_squares_resize = "false"
-- }}}

-- {{{ Misc
theme.awesome_icon           = themes_path .. "blueres/awesome-icon.svg"
theme.menu_submenu_icon      = themes_path .. "blueres/bar/submenu2.png"
-- }}}

-- {{{ Layout
theme.layout_tile       = themes_path .. "blueres/layouts/tile.svg"
theme.layout_tileleft   = themes_path .. "blueres/layouts/tileleft.svg"
theme.layout_tilebottom = themes_path .. "blueres/layouts/tilebottom.svg"
theme.layout_tiletop    = themes_path .. "blueres/layouts/tiletop.svg"
theme.layout_fairv      = themes_path .. "blueres/layouts/fair.svg"
theme.layout_fairh      = themes_path .. "blueres/layouts/fair.svg"
theme.layout_spiral     = themes_path .. "blueres/layouts/spiral.svg"
theme.layout_dwindle    = themes_path .. "blueres/layouts/spiral.svg"
theme.layout_max        = themes_path .. "blueres/layouts/max.svg"
theme.layout_fullscreen = themes_path .. "blueres/layouts/fullscreen.svg"
theme.layout_magnifier  = themes_path .. "blueres/layouts/magnifier.svg"
theme.layout_floating   = themes_path .. "blueres/layouts/floating.svg"
theme.layout_cornernw   = themes_path .. "blueres/layouts/cornernw.svg"
theme.layout_cornerne   = themes_path .. "blueres/layouts/cornerne.svg"
theme.layout_cornersw   = themes_path .. "blueres/layouts/cornersw.svg"
theme.layout_cornerse   = themes_path .. "blueres/layouts/cornerse.svg"
-- }}}

-- {{{ Titlebar
theme.titlebar_sticky_button_focus_active  = themes_path .. "blueres/titlebar/green.png"
theme.titlebar_sticky_button_normal_active = themes_path .. "blueres/titlebar/green.png"
theme.titlebar_sticky_button_focus_inactive  = themes_path .. "blueres/titlebar/grey.png"
theme.titlebar_sticky_button_normal_inactive = themes_path .. "blueres/titlebar/grey.png"

theme.titlebar_floating_button_focus_active  = themes_path .. "blueres/titlebar/grey.png"
theme.titlebar_floating_button_normal_active = themes_path .. "blueres/titlebar/grey.png"
theme.titlebar_floating_button_focus_inactive  = themes_path .. "blueres/titlebar/red.png"
theme.titlebar_floating_button_normal_inactive = themes_path .. "blueres/titlebar/red.png"

theme.titlebar_maximized_button_focus_active  = themes_path .. "blueres/titlebar/yellow.png"
theme.titlebar_maximized_button_normal_active = themes_path .. "blueres/titlebar/yellow.png"
theme.titlebar_maximized_button_focus_inactive  = themes_path .. "blueres/titlebar/grey.png"
theme.titlebar_maximized_button_normal_inactive = themes_path .. "blueres/titlebar/grey.png"
-- }}}
-- }}}

return theme

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
