local fn = vim.fn

-- Automatically install packer
local install_path = fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
  PACKER_BOOTSTRAP = fn.system {
    "git",
    "clone",
    "--depth",
    "1",
    "https://github.com/wbthomason/packer.nvim",
    install_path,
  }
  print "Installing packer close and reopen Neovim..."
  vim.cmd [[packadd packer.nvim]]
end

-- Reload neovim whenever plugins.lua is saved
vim.cmd [[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]]

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
    return
end

-- Have packer use a popup window goodness
packer.init {
    display = {
        open_fn = function()
            return require("packer.util").float { border = "rounded" }
        end,
    },
}

-- Plugin installation
return packer.startup(function(use)
    -- My plugins
    use "wbthomason/packer.nvim" -- Have packer manage itself
    use "nvim-lua/popup.nvim" -- An implementation of the Popup API from vim in Neovim
    use "nvim-lua/plenary.nvim" -- Useful lua functions used ny lots of plugins

    use "lukas-reineke/indent-blankline.nvim" -- Add lines to see indentation easier

    use { "nvim-treesitter/nvim-treesitter", run = ":TSUpdate"  }-- Syntax highlighting

    -- cmp
    use "hrsh7th/nvim-cmp" -- Completion plugin
    use "hrsh7th/cmp-buffer" -- for buffers
    use "hrsh7th/cmp-path" -- for path
    use "hrsh7th/cmp-cmdline" -- for cmdline
    use "saadparwaiz1/cmp_luasnip" -- for snippets
    use "hrsh7th/cmp-nvim-lsp" -- LSP completions

    -- Snippets
    use "L3MON4D3/LuaSnip" -- Snippet engine
    use "rafamadriz/friendly-snippets" -- Sippets to use

    -- LSP
    use "neovim/nvim-lspconfig" -- LSP itself
    use "williamboman/nvim-lsp-installer" -- Installer for language servers

    -- Telescope
    use "nvim-telescope/telescope.nvim"

    -- Autopairs
    use "windwp/nvim-autopairs"

    -- Colorscheme
    use "gruvbox-community/gruvbox"

    -- Automatically set up your configuration after cloning packer.nvim !NOTE! Don't put plugins after this boi
    if PACKER_BOOTSTRAP then
        require("packer").sync()
    end
end)
