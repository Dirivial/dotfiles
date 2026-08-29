{
  config,
  pkgs,
  lib,
  ...
}:
{

  imports = [
    ../../modules/dev/tools.nix
    ../../modules/desktop/dunst.nix
    ../../modules/desktop/hyprland.nix
    ../../modules/desktop/waybar.nix
    ../../modules/desktop/wlogout.nix
    ../../modules/desktop/wofi.nix
    ../../modules/editor/neovim.nix
    ../../modules/theme/catppuccin.nix
    ../../modules/terminal/alacritty.nix
    ../../modules/terminal/tmux.nix
    ../../modules/terminal/zsh.nix
  ];

  home.username = lib.mkDefault ("alkade");
  home.homeDirectory = lib.mkDefault ("/home/alkade");
  home.stateVersion = "25.11";

  home.packages = with pkgs; [
    bitwarden-desktop
    bmaptool
    brightnessctl
    codex
    cursor-clip
    gimp
    hyprpicker
    hyprshot
    hyprsunset
    kdePackages.dolphin
    localsend
    networkmanager_dmenu
    obsidian
    pavucontrol
    signal-cli
    signal-desktop
    spotify
    transmission_4-gtk
    vesktop
    wl-clipboard
  ];

  services.ssh-agent.enable = true;

  # DE
  services.awww.enable = true;

  programs.git = {
    enable = true;
    settings = {
      core.editor = "nvim";
      init.defaultBranch = "main";
      user = {
        name = "Alexander";
        email = "alexander.kadeby@gmail.com";
      };
    };
  };
}
