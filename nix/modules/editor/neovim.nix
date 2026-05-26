{ ... }:

{
  home.sessionVariables.NVIM_TOOLS_MANAGED_BY_NIX = "1";
  programs.zsh.sessionVariables.NVIM_TOOLS_MANAGED_BY_NIX = "1";

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    withPython3 = false;
    withRuby = false;
    # Keep the existing nvim submodule responsible for ~/.config/nvim/init.lua.
    sideloadInitLua = true;
  };
}
