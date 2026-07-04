{
  config,
  pkgs,
  lib,
  ...
}:
let
  catppuccinYazi = pkgs.fetchFromGitHub {
    owner = "catppuccin";
    repo = "yazi";
    rev = "main";
    sha256 = "sha256-L6SApM07CSQk0znEsFP8WaxW+ZHcindXo612r1XcwIg=";
  };
in
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

  home.packages = (with pkgs; [
    yazi
  ]) ++ (with pkgs; [
    bitwarden-desktop
    brightnessctl
    cursor-clip
    catppuccin-kde
    kdePackages.dolphin
    gimp
    hyprpicker
    hyprsunset
    obsidian
    pavucontrol
    signal-cli
    signal-desktop
    wl-clipboard
  ]);

  xdg.configFile."kdeglobals".text = ''
    [General]
    ColorScheme=CatppuccinFrappeBlue
  '';

  xdg.configFile."yazi/theme.toml".source =
    "${catppuccinYazi}/themes/frappe/catppuccin-frappe-blue.toml";

  xdg.dataFile."color-schemes/CatppuccinFrappeBlue.colors".source =
    "${pkgs.catppuccin-kde}/share/color-schemes/CatppuccinFrappeBlue.colors";

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
