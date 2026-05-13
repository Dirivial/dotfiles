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
    persistent = true,
})

for _, workspace in ipairs({ "2", "4", "5", "6", "7", "8", "10" }) do
    hl.workspace_rule({
        workspace = workspace,
        monitor = "desc:Samsung Electric Company Odyssey G85SB H1AK500000",
        persistent = true,
    })
end

hl.workspace_rule({
    workspace = "3",
    monitor = "desc:Samsung Electric Company Odyssey G85SB H1AK500000",
    default = true,
    persistent = true,
})

for _, workspace in ipairs({ "1", "3", "4", "5", "6", "7", "8", "9", "10" }) do
    hl.workspace_rule({
        workspace = workspace,
        monitor = "desc:Lenovo Group Limited LEN151WQXGA",
        persistent = true,
    })
end

hl.workspace_rule({
    workspace = "2",
    monitor = "desc:Lenovo Group Limited LEN151WQXGA",
    default = true,
    persistent = true,
})
