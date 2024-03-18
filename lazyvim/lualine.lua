return {
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = {
      options = {
        -- globalstatus = false,
        theme = "auto",
      },
      sections = {
        lualine_y = {
          { "encoding" },
          {
            function()
              local things = {
                "   🐣",
                "🪱 🐣",
                "🪱 🐤",
                "   🐓",
                "🐓 🥚",
                "   🥚",
              }
              return things[os.date("%S") % #things + 1]
            end,
          },
        },
        lualine_z = {
          { "progress", separator = " ", padding = { left = 1, right = 0 } },
          { "location", padding = { left = 0, right = 1 } },
        },
      },
    },
  },
}
