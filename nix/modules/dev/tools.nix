{ pkgs, ... }:

{
  home.packages = with pkgs; [
    fd
    lua-language-server
    nil
    nixfmt
    ripgrep
    shellcheck
    shfmt
    stylua
  ];

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
}
