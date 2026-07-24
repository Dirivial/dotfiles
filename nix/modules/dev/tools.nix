{ pkgs, ... }:

{
  home.packages = with pkgs; [
    clang-tools
    commitizen
    cpplint
    delve
    fd
    gcc
    gofumpt
    golangci-lint
    gopls
    jq
    lua-language-server
    markdownlint-cli
    nil
    nixfmt
    nodejs_24
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
