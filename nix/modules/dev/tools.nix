{ pkgs, ... }:

{
  home.packages = with pkgs; [
    clang-tools
    cpplint
    delve
    fd
    gofumpt
    golangci-lint
    gopls
    lua-language-server
    markdownlint-cli
    nil
    nixfmt
    ripgrep
    ruff
    shellcheck
    shfmt
    stylua
    ty
  ];

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
}
