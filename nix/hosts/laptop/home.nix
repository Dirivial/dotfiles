{ pkgs, ... }:

{
  imports = [
    ./alacritty.nix
  ];

  alkade.hyprland.profile = "laptop";

  home.packages = with pkgs; [
    bmaptool
    codex
    localsend
    networkmanager_dmenu
    spotify
    transmission_4-gtk
  ];

}
