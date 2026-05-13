hl.monitor({
    output = "desc:Samsung Electric Company Odyssey G85SB H1AK500000",
    mode = "preferred",
    position = "0x0",
    scale = 1,
})
hl.monitor({
    output = "desc:Lenovo Group Limited LEN151WQXGA",
    mode = "preferred",
    position = "0x1440",
    scale = 1,
})
hl.monitor({ output = "", mode = "preferred", position = "auto", scale = 1 })

hl.workspace_rule({
    workspace = "1",
    persistent = true,
    default_name = "main",
    monitor = "desc:Samsung Electric Company Odyssey G85SB H1AK500000",
    on_created_empty = "gimp",
})
hl.workspace_rule({
    workspace = "2",
    persistent = true,
    monitor = "desc:Samsung Electric Company Odyssey G85SB H1AK500000",
    on_created_empty = "zen-browser",
})
hl.workspace_rule({
    workspace = "3",
    persistent = true,
    monitor = "desc:Samsung Electric Company Odyssey G85SB H1AK500000",
    default = true,
    on_created_empty = "Alacritty",
})
hl.workspace_rule({
    workspace = "4",
    persistent = true,
    monitor = "desc:Samsung Electric Company Odyssey G85SB H1AK500000",
    on_created_empty = "code",
})

for _, workspace in ipairs({ "5", "6", "7", "8", "10" }) do
    hl.workspace_rule({
        workspace = workspace,
        persistent = true,
        monitor = "desc:Samsung Electric Company Odyssey G85SB H1AK500000",
    })
end

hl.workspace_rule({
    workspace = "9",
    monitor = "desc:Samsung Electric Company Odyssey G85SB H1AK500000",
    on_created_empty = "discord",
    persistent = true,
})
