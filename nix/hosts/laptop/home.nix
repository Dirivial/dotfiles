{ pkgs, ... }:

{
  imports = [
    ./alacritty.nix
  ];

  alkade.hyprland.profile = "laptop";

  home.packages = with pkgs; [
    codex
    localsend
    networkmanager_dmenu
  ];
  
}
