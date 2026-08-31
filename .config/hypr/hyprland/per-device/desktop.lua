hl.monitor({
    output = "desc:Acer Technologies Acer XB271H",
    mode = "1920x1080@143.98",
    position = "-1080x0",
    scale = 1,
    transform = 1,
})
hl.monitor({
    output = "desc:Samsung Electric Company Odyssey G85SB H1AK50000",
    mode = "3440x1440@119.96",
    position = "0x0",
    scale = 1,
})
hl.monitor({ output = "", mode = "preferred", position = "auto", scale = 1 })

hl.workspace_rule({
    workspace = "9",
    default_name = "side",
    monitor = "Acer Technologies Acer XB271H",
    default = true,
    on_created_empty = "discord",
    persistent = true,
})

hl.workspace_rule({
    workspace = "1",
    default_name = "main",
    monitor = "desc:Samsung Electric Company Odyssey G85SB H1AK500000",
    on_created_empty = "gimp",
    persistent = true,
})
hl.workspace_rule({
    workspace = "2",
    monitor = "desc:Samsung Electric Company Odyssey G85SB H1AK500000",
    on_created_empty = "Alacritty",
    persistent = true,
})
hl.workspace_rule({
    workspace = "3",
    monitor = "desc:Samsung Electric Company Odyssey G85SB H1AK500000",
    default = true,
    on_created_empty = "chromium",
    persistent = true,
})

for _, workspace in ipairs({ "4", "5", "6", "7", "8", "10" }) do
    hl.workspace_rule({
        workspace = workspace,
        monitor = "desc:Samsung Electric Company Odyssey G85SB H1AK500000",
        persistent = true,
    })
end
