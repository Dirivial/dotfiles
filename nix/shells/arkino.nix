{
  pkgs ? import <nixpkgs> { },
}:

pkgs.mkShell {
  packages = with pkgs; [
    python314Packages.vulture
    codespell
    python314Packages.pre-commit-hooks
    yamllint
  ];
}
