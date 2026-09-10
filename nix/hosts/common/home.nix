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

  xdg.configFile."whisper-dictation/config.yaml".text = ''
    hotkey:
      modifiers:
        - super
      key: comma
    input_device: ${if config.alkade.hyprland.profile == "desktop" then "Kinesis Kinesis Adv360" else "null"}
    audio_device: ${if config.alkade.hyprland.profile == "desktop" then "alsa_input.usb-Shure_Inc_Shure_MV7-00.mono-fallback" else "default"}
    whisper:
      model: base
      language: en
      threads: 4
    processing:
      remove_filler_words: true
      auto_capitalize: true
      auto_punctuate: false
    typing:
      key_delay: 0
      key_hold: 0
      start_delay: 0.3
  '';

  home.file.".local/share/whisper/models/ggml-base.bin".source = pkgs.fetchurl {
    url = "https://huggingface.co/ggerganov/whisper.cpp/resolve/main/ggml-base.bin";
    hash = "sha256-YO1bw90U7qhWST0zQ0m0BXgt3K8AKNS130CINF+6Lv4=";
  };

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
