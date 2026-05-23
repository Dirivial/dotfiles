{ config, pkgs, ... }:
{
  home.username = "alkade";
  home.homeDirectory = "/home/alkade";
  home.stateVersion = "25.11";

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
