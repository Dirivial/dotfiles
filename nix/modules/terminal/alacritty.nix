{
  config,
  pkgs,
  lib,
  ...
}:

{
  programs.alacritty = lib.mkDefault {
    enable = true;
    settings = {
      window = {
        opacity = 0.9;
        padding = {
          x = 5;
          y = 5;
        };
      };
      font = {
        size = 11.0;
        normal = {
          family = "Iosevka Nerd Font Mono";
          style = "Regular";
        };
      };
      colors = {
        primary = {
          background = "#1e1e2e";
          foreground = "#cdd6f4";
        };
      };
    };
  };
}
