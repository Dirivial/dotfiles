{ ... }:

{
  programs.waybar.enable = true;

  xdg.configFile."waybar" = {
    source = ../../../.config/waybar;
    recursive = true;
  };
}
