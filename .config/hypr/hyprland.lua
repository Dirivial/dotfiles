local function load_optional(module)
    local ok, err = pcall(require, module)
    if not ok and not tostring(err):match("module '" .. module .. "' not found") then
        error(err)
    end
    return ok
end

require("hyprland.colors")
require("hyprland.programs")

if not load_optional("hyprland.this-computer") then
    hl.monitor({ output = "", mode = "preferred", position = "auto", scale = 1 })
end

require("hyprland.execs")
require("hyprland.keybinds")

hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("LIBVA_DRIVER_NAME", "nvidia")
hl.env("__GLX_VENDOR_LIBRARY_NAME", "nvidia")

hl.config({
    general = {
        gaps_in = 4,
        gaps_out = 5,
        gaps_workspaces = 50,
        border_size = 2,
        col = {
            active_border = { colors = { "rgba(cba6f7ff)", "rgba(f38ba8ff)" }, angle = 220 },
            inactive_border = "rgba(11111bff)",
        },
        resize_on_border = false,
        allow_tearing = false,
        layout = "dwindle",
    },
    decoration = {
        rounding = 0,
        active_opacity = 1.0,
        inactive_opacity = 0.99,
        shadow = {
            enabled = true,
            range = 4,
            render_power = 3,
            color = "rgba(1a1a1aee)",
        },
        blur = {
            enabled = true,
            size = 3,
            passes = 1,
            vibrancy = 0.1696,
        },
    },
    animations = {
        enabled = true,
    },
    cursor = {
        no_hardware_cursors = true,
        min_refresh_rate = 120,
        hide_on_key_press = true,
    },
    dwindle = {
        preserve_split = true,
    },
    master = {
        new_status = "master",
    },
    misc = {
        force_default_wallpaper = 0,
        disable_hyprland_logo = true,
        allow_session_lock_restore = true,
        enable_swallow = false,
        swallow_regex = "(foot|kitty|Alacritty)",
    },
    input = {
        resolve_binds_by_sym = true,
        kb_layout = "se",
        kb_variant = "",
        kb_model = "",
        kb_options = "",
        kb_rules = "",
        follow_mouse = 1,
        sensitivity = 0.8,
        accel_profile = "flat",
        touchpad = {
            natural_scroll = false,
        },
    },
})

hl.curve("easeOutQuint", { type = "bezier", points = { { 0.23, 1 }, { 0.32, 1 } } })
hl.curve("easeInOutCubic", { type = "bezier", points = { { 0.65, 0.05 }, { 0.36, 1 } } })
hl.curve("linear", { type = "bezier", points = { { 0, 0 }, { 1, 1 } } })
hl.curve("almostLinear", { type = "bezier", points = { { 0.5, 0.5 }, { 0.75, 1.0 } } })
hl.curve("quick", { type = "bezier", points = { { 0.15, 0 }, { 0.1, 1 } } })

hl.animation({ leaf = "global", enabled = true, speed = 10, bezier = "default" })
hl.animation({ leaf = "border", enabled = true, speed = 5.39, bezier = "easeOutQuint" })
hl.animation({ leaf = "windows", enabled = true, speed = 4.79, bezier = "easeOutQuint" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 4.1, bezier = "easeOutQuint", style = "popin 87%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 1.49, bezier = "linear", style = "popin 87%" })
hl.animation({ leaf = "fadeIn", enabled = true, speed = 1.73, bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut", enabled = true, speed = 1.46, bezier = "almostLinear" })
hl.animation({ leaf = "fade", enabled = true, speed = 3.03, bezier = "quick" })
hl.animation({ leaf = "layers", enabled = true, speed = 3.81, bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn", enabled = true, speed = 4, bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "layersOut", enabled = true, speed = 1.5, bezier = "linear", style = "fade" })
hl.animation({ leaf = "fadeLayersIn", enabled = true, speed = 1.79, bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 1.39, bezier = "almostLinear" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesIn", enabled = true, speed = 1.21, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesOut", enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" })

for _, name in ipairs({
    "kinesis-kinesis-adv360",
    "kinesis-kinesis-adv360-1",
    "zsa-technology-labs-moonlander-mark-i",
    "zsa-technology-labs-moonlander-mark-i-system-control",
    "zsa-technology-labs-moonlander-mark-i-keyboard",
    "zsa-technology-labs-moonlander-mark-i-consumer-control",
}) do
    hl.device({
        name = name,
        kb_layout = "us",
        kb_variant = "altgr-intl",
        kb_model = "",
        kb_options = "",
        kb_rules = "",
    })
end
