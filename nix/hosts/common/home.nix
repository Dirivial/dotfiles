{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
let
  chromeLauncher = pkgs.writeShellScriptBin "google-chrome" ''
    exec ${pkgs.systemd}/bin/systemd-run --user --scope --collect --quiet \
      --slice=app-chrome.slice --expand-environment=no \
      -- ${pkgs.google-chrome}/bin/google-chrome-stable "$@"
  '';
  limitedChrome = pkgs.symlinkJoin {
    inherit (pkgs.google-chrome) name meta;
    paths = [ pkgs.google-chrome ];
    postBuild = ''
      ln -sf ${chromeLauncher}/bin/google-chrome "$out/bin/google-chrome"
      ln -sf ${chromeLauncher}/bin/google-chrome "$out/bin/google-chrome-stable"

      # Desktop entries use absolute paths, including new-window actions.
      for desktop in "$out"/share/applications/*.desktop; do
        substitute "$desktop" "$desktop.tmp" \
          --replace-fail "${pkgs.google-chrome}/bin/" "$out/bin/"
        mv "$desktop.tmp" "$desktop"
      done
    '';
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
    inputs.nixpkgs-unstable.legacyPackages.${pkgs.stdenv.hostPlatform.system}.codex
    cursor-clip
    gimp
    limitedChrome
    haruna
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
    inputs.nixpkgs-unstable.legacyPackages.${pkgs.stdenv.hostPlatform.system}.vesktop
    wl-clipboard
  ];

  # All Chrome launch scopes share one budget, including separate profiles.
  systemd.user.slices.app-chrome = {
    Unit.Description = "Google Chrome memory limits";
    Slice = {
      MemoryHigh = "6G";
      MemoryMax = "8G";
      MemorySwapMax = "1G";
    };
  };

  xdg.mimeApps = {
    enable = true;
    defaultApplications = lib.genAttrs [
      "video/mp2t"
      "video/mp4"
      "video/mpeg"
      "video/ogg"
      "video/quicktime"
      "video/vnd.avi"
      "video/webm"
      "video/x-matroska"
      "video/x-ms-wmv"
    ] (_: [ "org.kde.haruna.desktop" ]);
  };

  # Keep Haruna's playback history and GUI settings writable.
  home.activation.harunaTheme = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    run ${lib.getExe' pkgs.kdePackages.kconfig "kwriteconfig6"} \
      --file ${lib.escapeShellArg "${config.xdg.configHome}/haruna/haruna.conf"} \
      --group General --key ColorScheme "Catppuccin Mocha Blue"
  '';

  xdg.configFile."whisper-dictation/config.yaml".text = ''
    hotkey:
      modifiers:
        - super
      key: comma
    input_device: ${
      if config.alkade.hyprland.profile == "desktop" then "Kinesis Kinesis Adv360" else "null"
    }
    audio_device: ${
      if config.alkade.hyprland.profile == "desktop" then
        "alsa_input.usb-Shure_Inc_Shure_MV7-00.mono-fallback"
      else
        "default"
    }
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

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    settings."codex.microvm" = {
      User = "alkade";
      ForwardAgent = true;
    };
  };

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
