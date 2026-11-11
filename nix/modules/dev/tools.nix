{
  inputs,
  lib,
  pkgs,
  ...
}:

let
  codexAccount = pkgs.writeShellApplication {
    name = "codex-account";
    runtimeInputs = [ pkgs.coreutils ];
    text = builtins.readFile ../../../scripts/codex-account;
  };
in
{
  home.packages = with pkgs; [
    codexAccount
    inputs.nixpkgs-unstable.legacyPackages.${pkgs.stdenv.hostPlatform.system}.bootdev-cli
    clang-tools
    commitizen
    cpplint
    delve
    fd
    gcc
    gh
    #graphite-cli
    go
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

  programs.zsh.initContent = lib.mkAfter ''
    eval "$(codex-account shell-init)"
  '';
}
