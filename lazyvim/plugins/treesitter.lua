return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "tsx",
        "typescript",
        "templ",
        "go",
        "python",
        "lua",
        "json",
      })
    end,
  },
}
