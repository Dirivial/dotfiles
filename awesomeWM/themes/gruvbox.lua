local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local dpi   = require("beautiful.xresources").apply_dpi

local os = os
local my_table = awful.util.table or gears.table -- 4.{0,1} compatibility

local theme                                     = {}

theme.colors = {}
theme.colors.bg0   = "#282828"
theme.colors.bg1   = "#3c3836"
theme.colors.bg2   = "#504945"
theme.colors.bg3   = "#665c54"
theme.colors.bg4   = "#7c6f64"

theme.colors.gray   = "#928374"
theme.colors.gray_h  = "#a89984"

theme.colors.fg0     = "#839496"
theme.colors.fg1     = "#93a1a1"
theme.colors.fg2     = "#eee8d5"
theme.colors.fg3     = "#fdf6e3"
theme.colors.fg4     = "#fdf6e3"

theme.colors.yellow  = "#d79921"
theme.colors.yellow_h = "#fabd2f"

theme.colors.orange  = "#d65d0e"
theme.colors.orange_h = "#fe8019"

theme.colors.red     = "#cc241d"
theme.colors.red_h     = "#fb4934"

theme.colors.purple = "#b16286"
theme.colors.purple_h = "#d3869b"

theme.colors.blue    = "#458588"
theme.colors.blue_h    = "#83a598"

theme.colors.aqua   = "#689d6a"
theme.colors.aqua_h   = "#8ec07c"

theme.confdir                                   = os.getenv("HOME") .. "/.config/awesome/themes/"
theme.wallpaper                                 = theme.confdir .. "/wallpapers/gruvbox/leaves.jpg"
theme.font                                      = "inter-font 12"

theme.menu_bg_normal                            = theme.colors.bg0
theme.menu_bg_focus                             = theme.colors.bg2

theme.bg_normal                                 = theme.colors.bg0
theme.bg_focus                                  = theme.colors.bg1
theme.bg_urgent                                 = theme.colors.bg3

theme.fg_normal                                 = theme.colors.fg1
theme.fg_focus                                  = theme.colors.fg0
theme.fg_urgent                                 = theme.colors.orange
theme.fg_minimize                               = theme.colors.fg4

theme.border_width                              = dpi(1)
theme.border_normal                             = theme.colors.fg0
theme.border_focus                              = theme.colors.fg4
theme.border_marked                             = theme.colors.red

theme.menu_border_width                         = 0
theme.menu_width                                = dpi(130)
theme.menu_submenu_icon                         = theme.confdir .. "/icons/submenu.png"
theme.menu_fg_normal                            = theme.colors.fg1
theme.menu_fg_focus                             = theme.colors.fg0

theme.widget_temp                               = theme.confdir .. "/icons/temp.png"
theme.widget_uptime                             = theme.confdir .. "/icons/ac.png"
theme.widget_cpu                                = theme.confdir .. "/icons/cpu.png"
theme.widget_weather                            = theme.confdir .. "/icons/dish.png"
theme.widget_fs                                 = theme.confdir .. "/icons/fs.png"
theme.widget_mem                                = theme.confdir .. "/icons/mem.png"
theme.widget_note                               = theme.confdir .. "/icons/note.png"
theme.widget_note_on                            = theme.confdir .. "/icons/note_on.png"
theme.widget_netdown                            = theme.confdir .. "/icons/net_down.png"
theme.widget_netup                              = theme.confdir .. "/icons/net_up.png"
theme.widget_mail                               = theme.confdir .. "/icons/mail.png"
theme.widget_batt                               = theme.confdir .. "/icons/bat.png"
theme.widget_clock                              = theme.confdir .. "/icons/clock.png"
theme.widget_vol                                = theme.confdir .. "/icons/spkr.png"

theme.taglist_squares_sel                       = theme.confdir .. "/icons/square_a.png"
theme.taglist_squares_unsel                     = theme.confdir .. "/icons/square_b.png"

theme.tasklist_plain_task_name                  = true
theme.tasklist_disable_icon                     = true

theme.useless_gap                               = 3

theme.layout_tile                               = theme.confdir .. "/icons/tile.png"
theme.layout_tilegaps                           = theme.confdir .. "/icons/tilegaps.png"
theme.layout_tileleft                           = theme.confdir .. "/icons/tileleft.png"
theme.layout_tilebottom                         = theme.confdir .. "/icons/tilebottom.png"
theme.layout_tiletop                            = theme.confdir .. "/icons/tiletop.png"
theme.layout_fairv                              = theme.confdir .. "/icons/fairv.png"
theme.layout_fairh                              = theme.confdir .. "/icons/fairh.png"
theme.layout_spiral                             = theme.confdir .. "/icons/spiral.png"
theme.layout_dwindle                            = theme.confdir .. "/icons/dwindle.png"
theme.layout_max                                = theme.confdir .. "/icons/max.png"
theme.layout_fullscreen                         = theme.confdir .. "/icons/fullscreen.png"
theme.layout_magnifier                          = theme.confdir .. "/icons/magnifier.png"
theme.layout_floating                           = theme.confdir .. "/icons/floating.png"
theme.layout_centerwork                         = theme.confdir .. "/icons/center.png"

-- Titlebar stuff
theme.titlebar_close_button_normal              = theme.confdir .. "/icons/titlebar/close_normal.png"
theme.titlebar_close_button_focus               = theme.confdir .. "/icons/titlebar/close_focus.png"
theme.titlebar_minimize_button_normal           = theme.confdir .. "/icons/titlebar/minimize_normal.png"
theme.titlebar_minimize_button_focus            = theme.confdir .. "/icons/titlebar/minimize_focus.png"
theme.titlebar_ontop_button_normal_inactive     = theme.confdir .. "/icons/titlebar/ontop_normal_inactive.png"
theme.titlebar_ontop_button_focus_inactive      = theme.confdir .. "/icons/titlebar/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_active       = theme.confdir .. "/icons/titlebar/ontop_normal_active.png"
theme.titlebar_ontop_button_focus_active        = theme.confdir .. "/icons/titlebar/ontop_focus_active.png"
theme.titlebar_sticky_button_normal_inactive    = theme.confdir .. "/icons/titlebar/sticky_normal_inactive.png"
theme.titlebar_sticky_button_focus_inactive     = theme.confdir .. "/icons/titlebar/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_active      = theme.confdir .. "/icons/titlebar/sticky_normal_active.png"
theme.titlebar_sticky_button_focus_active       = theme.confdir .. "/icons/titlebar/sticky_focus_active.png"
theme.titlebar_floating_button_normal_inactive  = theme.confdir .. "/icons/titlebar/floating_normal_inactive.png"
theme.titlebar_floating_button_focus_inactive   = theme.confdir .. "/icons/titlebar/floating_focus_inactive.png"
theme.titlebar_floating_button_normal_active    = theme.confdir .. "/icons/titlebar/floating_normal_active.png"
theme.titlebar_floating_button_focus_active     = theme.confdir .. "/icons/titlebar/floating_focus_active.png"
theme.titlebar_maximized_button_normal_inactive = theme.confdir .. "/icons/titlebar/maximized_normal_inactive.png"
theme.titlebar_maximized_button_focus_inactive  = theme.confdir .. "/icons/titlebar/maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_active   = theme.confdir .. "/icons/titlebar/maximized_normal_active.png"
theme.titlebar_maximized_button_focus_active    = theme.confdir .. "/icons/titlebar/maximized_focus_active.png"
-- End of titlebar stuff

-- Nofitication settings
theme.notification_icon_size = dpi(120)
theme.notification_max_width = dpi(450)

-- Taglist setting

theme.taglist_bg_empty = theme.colors.bg2
theme.taglist_bg_occupied = theme.colors.bg2
theme.taglist_bg_focus = theme.colors.bg4

theme.bg_systray = theme.colors.bg2

theme.taglist_font                              = "FontAwesome 14"
awful.util.tagnames = { "[1]", "[2]", "[3]", "[4]", "[5]", "[6]" }

local build_widget = function(widget)
  return wibox.widget {
    {
      widget,
      border_width = dpi(2),
          border_color = theme.color.orange,
      bg = beautiful.transparent,
      shape = function(cr, w, h)
        gears.shape.rounded_rect(cr, w, h, dpi(12))
      end,
      widget = wibox.container.background
    },
    top = dpi(9),
    bottom = dpi(9),
    widget = wibox.container.margin
  }
end



-- Widgets
mykeyboardlayout = awful.widget.keyboardlayout()

-- Textclock
os.setlocale(os.getenv("LANG")) -- to localize the clock
local mytextclock = wibox.widget.textclock()
mytextclock.font = theme.font

local pipe_character = wibox.widget {
  markup = ' | ',
  align = 'center',
  valign = 'center',
  widget = wibox.widget.textbox
}

local right_rect = function(cr, width, height)
    gears.shape.partially_rounded_rect(cr, 10, 24, false, true, true, false, 30)
end

local my_separator = wibox.widget {
    shape = right_rect,
    color = theme.colors.bg2,
    forced_width = 15,
    widget = wibox.widget.separator,
}

function theme.at_screen_connect(s)
    -- Wallpaper
    local wallpaper = theme.wallpaper
    if type(wallpaper) == "function" then
        wallpaper = wallpaper(s)
    end
    gears.wallpaper.maximized(wallpaper, s, true)

    -- Tags
    awful.tag(awful.util.tagnames, s, awful.layout.layouts_start)

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(my_table.join(
                           awful.button({}, 1, function () awful.layout.inc( 1) end),
                           awful.button({}, 2, function () awful.layout.set( awful.layout.layouts[1] ) end),
                           awful.button({}, 3, function () awful.layout.inc(-1) end),
                           awful.button({}, 4, function () awful.layout.inc( 1) end),
                           awful.button({}, 5, function () awful.layout.inc(-1) end)))
    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist(s, awful.widget.taglist.filter.all, awful.util.taglist_buttons)

    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, awful.util.tasklist_buttons)

    -- Create the wibox
    s.mywibox = awful.wibar({ position = "top", screen = s, height = dpi(24), bg = theme.colors.bg2, fg = theme.fg_normal })

    -- Add widgets to the wibox
    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        expand = "none",
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            my_separator,
            s.mylayoutbox,
            {
                pipe_character,
                bg = theme.colors.bg2,
                widget = wibox.container.background,
            },
            s.mytasklist,
            s.mypromptbox,
            my_separator,
        },
        s.mytaglist, -- Middle widget,
        { -- Right
            layout = wibox.layout.fixed.horizontal,
            my_separator,
            wibox.widget.systray(),
            pipe_character,
            mykeyboardlayout,
            {
                pipe_character,
                bg = theme.colors.bg2,
                widget = wibox.container.background,
            },
            mytextclock,
            my_separator,
        },

    }
end


return theme
