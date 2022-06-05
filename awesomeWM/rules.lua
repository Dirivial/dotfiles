local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
local wibox         = require("wibox")
local beautiful     = require("beautiful")
local naughty       = require("naughty")
--local menubar       = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")
require("awful.hotkeys_popup.keys")

local tagnames = { "", "", "", "", "", "" }

return {
  -- All clients will match this rule.
  { rule = {},
    properties = { border_width = beautiful.border_width,
      border_color = beautiful.border_normal,
      focus = awful.client.focus.filter,
      raise = true,
      keys = clientkeys,
      buttons = clientbuttons,
      screen = awful.screen.preferred,
      placement = awful.placement.no_overlap + awful.placement.no_offscreen,
      size_hints_honor = false
    }
  },

  -- Floating clients.
  { rule_any = {
    instance = {
      "DTA", -- Firefox addon DownThemAll.
      "copyq", -- Includes session name in class.
      "pinentry",
    },
    class = {
      "Arandr",
      "Blueman-manager",
      "Gpick",
      "Kruler",
      "MessageWin", -- kalarm.
      "Sxiv",
      "Tor Browser", -- Needs a fixed window size to avoid fingerprinting by screen size.
      "Wpa_gui",
      "veromix",
      "xtightvncviewer" },

    -- Note that the name property shown in xprop might be set slightly after creation of the client
    -- and the name shown there might not match defined rules here.
    name = {
      "Event Tester", -- xev.
    },
    role = {
      "AlarmWindow", -- Thunderbird's calendar.
      "ConfigManager", -- Thunderbird's about:config.
      "pop-up", -- e.g. Google Chrome's (detached) Developer Tools.
    }
  }, properties = { floating = true } },

  -- Add titlebars to normal clients and dialogs
  { rule_any = { type = { "normal", "dialog" }
  }, properties = { titlebars_enabled = true }
  },

  -- Very specific rules
  { rule = { instance = "discord" },
    properties = { screen = 2, tag = '1' } },
  { rule_any = { class = {"Spotify", "spotify" }},
    properties = { screen = 1, tag = '5' } },
  { rule = { instance = "brave-browser" },
    properties = { tag = '3' } },
  { rule = { class = "conky-semi" },
    properties = {
      floating = true,
      screen = 1
    }
  },
  { rule = { instance = "pavucontrol" },
    properties = { screen = 1, tag = tagnames[0] } },
}
