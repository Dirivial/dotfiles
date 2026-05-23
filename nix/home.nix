{ config, pkgs, ... }:
{
  home.username = "alkade";
  home.homeDirectory = "/home/alkade";
  home.stateVersion = "25.11";

  programs.bash.enable = true;

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
