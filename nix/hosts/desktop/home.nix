{ config, pkgs, ... }:
{
  alkade.hyprland.profile = "desktop";

  home.packages = [ pkgs.prismlauncher ];
}
