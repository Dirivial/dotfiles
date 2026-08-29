{ pkgs, ... }:

{
  imports = [
    ./alacritty.nix
  ];

  alkade.hyprland.profile = "laptop";
}
