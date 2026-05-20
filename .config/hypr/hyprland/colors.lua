local hyprbars = hl.plugin and hl.plugin.hyprbars

hl.config({
    general = {
        col = {
            active_border = "rgba(F7DCDE39)",
            inactive_border = "rgba(A58A8D30)",
        },
    },
    misc = {
        background_color = "rgba(1D1011FF)",
    },
})

if not (hyprbars and hyprbars.add_button) then
    return
end

hl.config({
    plugin = {
        hyprbars = {
            bar_text_font = "Rubik, Geist, AR One Sans, Reddit Sans, Inter, Roboto, Ubuntu, Noto Sans, sans-serif",
            bar_height = 30,
            bar_padding = 10,
            bar_button_padding = 5,
            bar_precedence_over_border = true,
            bar_part_of_window = true,
            bar_color = "rgba(1D1011FF)",
            col = {
                text = "rgba(F7DCDEFF)",
            },
        },
    },
})

hyprbars.add_button({
    bg_color = "rgb(F7DCDE)",
    fg_color = "rgb(1D1011)",
    size = 13,
    icon = "󰖭",
    action = "hyprctl dispatch 'hl.dsp.window.close()'",
})

hyprbars.add_button({
    bg_color = "rgb(F7DCDE)",
    fg_color = "rgb(1D1011)",
    size = 13,
    icon = "󰖯",
    action = "hyprctl dispatch 'hl.dsp.window.fullscreen({ mode = \"maximized\" })'",
})

hyprbars.add_button({
    bg_color = "rgb(F7DCDE)",
    fg_color = "rgb(1D1011)",
    size = 13,
    icon = "󰖰",
    action = "hyprctl dispatch 'hl.dsp.window.move({ workspace = \"special\" })'",
})
