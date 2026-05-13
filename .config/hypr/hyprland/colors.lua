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
            -- Hyprbars exposes this as a repeated plugin keyword in hyprlang.
            -- Lua plugin keyword support is not yet documented on the wiki.
            ["hyprbars-button"] = {
                { "rgb(F7DCDE)", 13, "󰖭", "hyprctl dispatch 'hl.dsp.window.close()'" },
                { "rgb(F7DCDE)", 13, "󰖯", "hyprctl dispatch 'hl.dsp.window.fullscreen({ mode = \"maximized\" })'" },
                { "rgb(F7DCDE)", 13, "󰖰", "hyprctl dispatch 'hl.dsp.window.move({ workspace = \"special\" })'" },
            },
        },
    },
})
