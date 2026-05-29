{ pkgs, ... }:

{
  home.packages = with pkgs; [
    clang-tools
    commitizen
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
    python3
    ripgrep
    ruff
    shellcheck
    shfmt
    stylua
    ty
    uv
  ];

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
}
