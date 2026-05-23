{ config, pkgs, lib, ... }:
{
  home.username = lib.mkDefault("alkade");
  home.homeDirectory = lib.mkDefault("/home/alkade");
  home.stateVersion = "25.11";

  home.packages = with pkgs; [
    bitwarden-desktop
    hyprsunset
  ];

  programs.bash.enable = true;
  programs.tmux.enable = true;

  # DE
  services.awww.enable = true;
  services.dunst.enable = true;
  programs.waybar.enable = true;
  programs.wlogout.enable = true;
  

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
