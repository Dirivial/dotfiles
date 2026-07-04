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
    ../../modules/terminal/alacritty.nix
    ../../modules/terminal/tmux.nix
    ../../modules/terminal/zsh.nix
  ];

  home.username = lib.mkDefault ("alkade");
  home.homeDirectory = lib.mkDefault ("/home/alkade");
  home.stateVersion = "25.11";

  home.packages = with pkgs; [
    bitwarden-desktop
    brightnessctl
    cursor-clip
    gimp
    hyprpicker
    hyprsunset
    obsidian
    pavucontrol
    signal-cli
    signal-desktop
    wl-clipboard
  ];

  programs.bash.enable = true;

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
