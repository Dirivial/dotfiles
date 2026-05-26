{ config, lib, ... }:

let
  cfg = config.alkade.hyprland;
in
{
  options.alkade.hyprland.profile = lib.mkOption {
    type = lib.types.enum [ "desktop" "laptop" ];
    description = "Device-specific Hyprland profile to load.";
  };

  config.xdg.configFile = {
    "hypr/hyprland.lua".source = ../../../.config/hypr/hyprland.lua;
    "hypr/hypridle.conf".source = ../../../.config/hypr/hypridle.conf;
    "hypr/hyprlock.conf".source = ../../../.config/hypr/hyprlock.conf;
    "hypr/hyprsunset.conf".source = ../../../.config/hypr/hyprsunset.conf;

    "hypr/hyprland/colors.lua".source = ../../../.config/hypr/hyprland/colors.lua;
    "hypr/hyprland/execs.lua".source = ../../../.config/hypr/hyprland/execs.lua;
    "hypr/hyprland/keybinds.lua".source = ../../../.config/hypr/hyprland/keybinds.lua;
    "hypr/hyprland/programs.lua".source = ../../../.config/hypr/hyprland/programs.lua;
    "hypr/hyprland/this-computer.lua".text = ''
      require("hyprland.per-device.${cfg.profile}")
    '';

    "hypr/hyprland/per-device" = {
      source = ../../../.config/hypr/hyprland/per-device;
      recursive = true;
    };

    "hypr/hyprland/scripts" = {
      source = ../../../.config/hypr/hyprland/scripts;
      recursive = true;
    };

    "hypr/hyprlock" = {
      source = ../../../.config/hypr/hyprlock;
      recursive = true;
    };

    "hypr/hyprpaper" = {
      source = ../../../.config/hypr/hyprpaper;
      recursive = true;
    };
  };
}
