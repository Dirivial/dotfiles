local laptop_description = "Lenovo Group Limited LEN151WQXGA"
local laptop_monitor = "desc:" .. laptop_description
local main_workspaces = { "1", "2", "3", "4", "5" }
local laptop_workspaces = { "6", "7", "8", "9", "10" }

local function get_external_monitor()
    for _, monitor in ipairs(hl.get_monitors()) do
        if monitor.description ~= laptop_description then
            return monitor.name
        end
    end

    return nil
end

local function move_workspace(workspace, monitor)
    hl.dispatch(hl.dsp.workspace.move({ workspace = workspace, monitor = monitor }))
end

local function apply_workspace_layout()
    local main_monitor = get_external_monitor() or laptop_monitor

    for _, workspace in ipairs(main_workspaces) do
        move_workspace(workspace, main_monitor)
    end

    for _, workspace in ipairs(laptop_workspaces) do
        move_workspace(workspace, laptop_monitor)
    end
end

local function schedule_workspace_layout()
    hl.timer(apply_workspace_layout, { timeout = 250, type = "oneshot" })
end

hl.monitor({
    output = laptop_monitor,
    mode = "preferred",
    position = "auto-down",
    scale = 1,
})
hl.monitor({ output = "", mode = "preferred", position = "auto", scale = 1 })

hl.workspace_rule({
    workspace = "1",
    persistent = true,
    default_name = "main",
    on_created_empty = "gimp",
})
hl.workspace_rule({
    workspace = "2",
    persistent = true,
    on_created_empty = "Alacritty",
})
hl.workspace_rule({
    workspace = "3",
    persistent = true,
    on_created_empty = "chromium",
})

for _, workspace in ipairs({ "4", "5" }) do
    hl.workspace_rule({
        workspace = workspace,
        persistent = true,
    })
end

hl.workspace_rule({
    workspace = "6",
    persistent = true,
    monitor = laptop_monitor,
    default = true,
})
hl.workspace_rule({
    workspace = "8",
    persistent = true,
    monitor = laptop_monitor,
})
hl.workspace_rule({
    workspace = "9",
    monitor = laptop_monitor,
    on_created_empty = "vesktop",
    persistent = true,
})

for _, workspace in ipairs({ "7", "10" }) do
    hl.workspace_rule({
        workspace = workspace,
        persistent = true,
        monitor = laptop_monitor,
    })
end

hl.on("config.reloaded", schedule_workspace_layout)
hl.on("hyprland.start", schedule_workspace_layout)
hl.on("monitor.added", schedule_workspace_layout)
hl.on("monitor.layout_changed", schedule_workspace_layout)
hl.on("monitor.removed", schedule_workspace_layout)
