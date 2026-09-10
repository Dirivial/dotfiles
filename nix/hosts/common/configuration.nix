{
  config,
  lib,
  pkgs,
  inputs,
  whisperCuda ? false,
  ...
}:
let
  nativeCompatLibraries = with pkgs; [
    stdenv.cc.cc.lib
    zlib
    libGL
    glib
  ];
  dictationPaste = pkgs.writeText "whisper-dictation-paste.py" ''
    import json
    import logging
    import subprocess
    import time

    logger = logging.getLogger(__name__)
    TERMINAL_CLASSES = {
        "alacritty", "kitty", "foot", "ghostty", "wezterm",
        "org.wezfurlong.wezterm", "com.mitchellh.ghostty",
    }

    class TextPaster:
        def __init__(self, config):
            self.config = config

        @staticmethod
        def active_window_class():
            try:
                result = subprocess.run(
                    ["hyprctl", "activewindow", "-j"],
                    capture_output=True, text=True, check=True,
                )
                return json.loads(result.stdout).get("class", "").lower()
            except (OSError, ValueError, subprocess.CalledProcessError):
                return ""

        def paste(self, text):
            if not text:
                return
            logger.info("Pasting text: %s...", text[:50])
            time.sleep(self.config.get("typing.start_delay", 0.3))
            subprocess.run(
                ["wl-copy", "--trim-newline"],
                input=text, text=True, check=True,
            )
            if self.active_window_class() in TERMINAL_CLASSES:
                shortcut = [
                    "wtype", "-M", "ctrl", "-M", "shift", "-k", "v",
                    "-m", "shift", "-m", "ctrl",
                ]
            else:
                shortcut = ["wtype", "-M", "ctrl", "-k", "v", "-m", "ctrl"]
            subprocess.run(shortcut, check=True)
            logger.info("Text pasted successfully")
  '';
  whisperCpp = pkgs.whisper-cpp.override { cudaSupport = whisperCuda; };
  whisperDictationBase = inputs.whisper-dictation.lib.${pkgs.stdenv.hostPlatform.system}.mkWhisperDictation whisperCpp;
  whisperDictation = whisperDictationBase.overrideAttrs (old: {
    postPatch = (old.postPatch or "") + ''
      substituteInPlace src/whisper_dictation/daemon.py \
        --replace-fail \
          "if configured_device in device.name or configured_device == device_path:" \
          "if configured_device == device.name or configured_device == device_path:"
      substituteInPlace src/whisper_dictation/recorder.py \
        --replace-fail \
          '"default",  # Default microphone' \
          'self.config.get("audio_device", "default"),'
      cp ${dictationPaste} src/whisper_dictation/paste.py
    '';
  });
in
{
  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "alkade"; # Define your hostname.

  # Configure network connections interactively with nmcli or nmtui.
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Stockholm";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    #keyMap = "us";
    #useXkbConfig = true; # use xkb.options in tty.
  };

  # Enable the X11 windowing system.
  services.xserver.enable = false;

  services.printing = {
    enable = true;
    drivers = with pkgs; [
      gutenprint
    ];
  };

  # Enable sound.
  services.pulseaudio.enable = false;

  # RealtimeKit
  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Bluetooth
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  hardware.acpilight.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.alkade = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [
      "input"
      "wheel"
      "networkmanager"
      "video"
      "ydotool"
    ];
    packages = with pkgs; [
      tree
    ];
  };

  programs.firefox.enable = true;
  programs.ydotool.enable = true;
  programs.zsh.enable = true;
  programs.nix-ld = {
    enable = true;
    libraries = nativeCompatLibraries;
  };
  virtualisation.podman.enable = true;
  programs.regreet = {
    enable = true;
    # ReGreet is a single-monitor application.  Cage otherwise extends it
    # across every connected output, which breaks its pointer hit testing.
    cageArgs = [ "-s" "-d" "-m" "last" ];
    settings = {
      background = {
        path = ../../../.config/hypr/hyprpaper/dark-forest-village.png;
        fit = "Cover";
      };
      GTK.application_prefer_dark_theme = true;
    };
    font = {
      package = pkgs.nerd-fonts.iosevka;
      name = "Iosevka Nerd Font";
      size = 16;
    };
  };

  nixpkgs.config.allowUnfreePredicate =
    pkg:
    let
      name = lib.getName pkg;
    in
    builtins.elem name [
      "nvidia-settings"
      "nvidia-x11"
      "obsidian"
      "spotify"
      "steam"
      "steam-original"
      "steam-unwrapped"
    ]
    || lib.hasPrefix "cuda" name
    || lib.hasPrefix "cudnn" name
    || lib.hasPrefix "libcu" name;
  nixpkgs.config.permittedInsecurePackages = [
    "electron-39.8.10"
  ];

  environment.sessionVariables = {
    SHELL = "${pkgs.zsh}/bin/zsh";
  };

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    package = pkgs.hyprland;
    portalPackage = pkgs.xdg-desktop-portal-hyprland;
  };

  fonts = {
    fontconfig.enable = true;
    packages = with pkgs; [
      nerd-fonts.iosevka
    ];
  };

  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  environment.systemPackages = with pkgs; [
    alacritty
    bubblewrap
    busybox
    chromium
    e2fsprogs
    kitty
    lazygit
    vim
    waybar
    wget
    wofi
    zsh
  ] ++ [
    whisperDictation
  ];

  systemd.user.services.whisper-dictation = {
    description = "Local Whisper speech-to-text dictation";
    after = [ "graphical-session.target" ];
    wantedBy = [ "graphical-session.target" ];
    path = [
      pkgs.hyprland
      pkgs.procps
      pkgs.ydotool
      pkgs.wl-clipboard
      pkgs.wtype
    ];
    serviceConfig = {
      Environment = [
        "GI_TYPELIB_PATH=${lib.makeSearchPath "lib/girepository-1.0" [
          pkgs.gdk-pixbuf
          pkgs.graphene
          pkgs.gtk4
          pkgs.harfbuzz
          pkgs.gobject-introspection
          (lib.getLib pkgs.pango)
        ]}"
        "YDOTOOL_SOCKET=/run/ydotoold/socket"
      ];
      ExecStart = "${whisperDictation}/bin/whisper-dictation --verbose";
      Restart = "on-failure";
      RestartSec = 5;
    };
  };

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  services.cron = {
    enable = true;
    systemCronJobs = [
      "*/30 * * * * alkade PATH=${
        lib.makeBinPath [
          pkgs.coreutils
          pkgs.dunst
          pkgs.git
          pkgs.gnugrep
        ]
      }:/run/current-system/sw/bin /home/alkade/dotfiles/scripts/vault_sync.sh"
    ];
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

}
