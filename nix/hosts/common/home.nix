{ config, pkgs, lib, ... }:
{

  imports = [
    ../../modules/desktop/dunst.nix
    ../../modules/desktop/waybar.nix
    ../../modules/desktop/wlogout.nix
    ../../modules/desktop/wofi.nix
    ../../modules/terminal/alacritty.nix
  ];

  home.username = lib.mkDefault("alkade");
  home.homeDirectory = lib.mkDefault("/home/alkade");
  home.stateVersion = "25.11";

  home.packages = with pkgs; [
    bitwarden-desktop
    hyprsunset
    signal-desktop
  ];

  programs.bash.enable = true;
  programs.tmux.enable = true;

  # DE
  services.awww.enable = true;
  

  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Alexander";
        email = "alexander.kadeby@gmail.com";
      };
    };
  };
}
