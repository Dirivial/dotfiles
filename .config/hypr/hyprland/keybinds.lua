local mainMod = "SUPER"

hl.bind(mainMod .. " + T", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + W", hl.dsp.window.close())
hl.bind(mainMod .. " + Q", hl.dsp.exit())
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + F", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + M", hl.dsp.window.fullscreen({ mode = "maximized" }))
hl.bind(mainMod .. " + SHIFT + M", hl.dsp.window.fullscreen({ mode = "fullscreen" }))
hl.bind(mainMod .. " + R", hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + S", hl.dsp.exec_cmd("~/.config/hypr/hyprland/scripts/grimshot.sh"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.exec_cmd("~/.config/hypr/hyprland/scripts/hyprsunset.sh"))
hl.bind(mainMod .. " + period", hl.dsp.exec_cmd("~/.config/hypr/hyprland/scripts/emoji-selector.sh"))

hl.bind(mainMod .. " + X", hl.dsp.exec_cmd("pkill -SIGUSR1 waybar || waybar"))
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())
hl.bind(mainMod .. " + SHIFT + P", hl.dsp.submap("clean-clipboard-indent"))
hl.bind("ALT + L", hl.dsp.exec_cmd("wlogout -b 2"))

local cleanClipboardIndentScript = "~/.config/hypr/hyprland/scripts/clean-clipboard-indent.sh"
local function clean_clipboard_indent(mode)
    return hl.dsp.exec_cmd(cleanClipboardIndentScript .. " " .. mode)
end

hl.define_submap("clean-clipboard-indent", function()
    hl.bind("A", clean_clipboard_indent("trim-lines"))
    hl.bind("a", clean_clipboard_indent("trim-lines"))
    hl.bind("S", clean_clipboard_indent("trim-start"))
    hl.bind("s", clean_clipboard_indent("trim-start"))
    hl.bind("T", clean_clipboard_indent("remove-two-spaces"))
    hl.bind("t", clean_clipboard_indent("remove-two-spaces"))
    hl.bind("escape", hl.dsp.submap("reset"))
    hl.bind("CTRL + C", hl.dsp.submap("reset"))
end)

hl.bind(mainMod .. " + H", hl.dsp.focus({ direction = "l" }))
hl.bind(mainMod .. " + L", hl.dsp.focus({ direction = "r" }))
hl.bind(mainMod .. " + K", hl.dsp.focus({ direction = "u" }))
hl.bind(mainMod .. " + J", hl.dsp.focus({ direction = "d" }))

hl.bind(mainMod .. " + SHIFT + H", hl.dsp.window.move({ direction = "l" }))
hl.bind(mainMod .. " + SHIFT + L", hl.dsp.window.move({ direction = "r" }))
hl.bind(mainMod .. " + SHIFT + K", hl.dsp.window.move({ direction = "u" }))
hl.bind(mainMod .. " + SHIFT + J", hl.dsp.window.move({ direction = "d" }))

for key = 1, 9 do
    hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = key }))
    hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = key }))
end

hl.bind(mainMod .. " + 0", hl.dsp.focus({ workspace = 10 }))
hl.bind(mainMod .. " + SHIFT + 0", hl.dsp.window.move({ workspace = 10 }))

hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

hl.bind("ALT + R", hl.dsp.submap("resize"))
hl.define_submap("resize", function()
    hl.bind("L", hl.dsp.window.resize({ x = 10, y = 0, relative = true }), { repeating = true })
    hl.bind("H", hl.dsp.window.resize({ x = -10, y = 0, relative = true }), { repeating = true })
    hl.bind("K", hl.dsp.window.resize({ x = 0, y = -10, relative = true }), { repeating = true })
    hl.bind("J", hl.dsp.window.resize({ x = 0, y = 10, relative = true }), { repeating = true })

    hl.bind("SHIFT + L", hl.dsp.window.resize({ x = 20, y = 0, relative = true }), { repeating = true })
    hl.bind("SHIFT + H", hl.dsp.window.resize({ x = -20, y = 0, relative = true }), { repeating = true })
    hl.bind("SHIFT + K", hl.dsp.window.resize({ x = 0, y = -20, relative = true }), { repeating = true })
    hl.bind("SHIFT + J", hl.dsp.window.resize({ x = 0, y = 20, relative = true }), { repeating = true })

    hl.bind(mainMod .. " + SHIFT + L", hl.dsp.window.resize({ x = 150, y = 0, relative = true }), { repeating = true })
    hl.bind(mainMod .. " + SHIFT + H", hl.dsp.window.resize({ x = -150, y = 0, relative = true }), { repeating = true })
    hl.bind(mainMod .. " + SHIFT + K", hl.dsp.window.resize({ x = 0, y = -150, relative = true }), { repeating = true })
    hl.bind(mainMod .. " + SHIFT + J", hl.dsp.window.resize({ x = 0, y = 150, relative = true }), { repeating = true })

    hl.bind("escape", hl.dsp.submap("reset"))
    hl.bind("CTRL + C", hl.dsp.submap("reset"))
end)

hl.bind(
    "XF86AudioRaiseVolume",
    hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"),
    { locked = true, repeating = true }
)
hl.bind(
    "XF86AudioLowerVolume",
    hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),
    { locked = true, repeating = true }
)
hl.bind(
    "XF86AudioMute",
    hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),
    { locked = true, repeating = true }
)
hl.bind(
    "XF86AudioMicMute",
    hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),
    { locked = true, repeating = true }
)
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl s 10%+"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl s 10%-"), { locked = true, repeating = true })

hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })
