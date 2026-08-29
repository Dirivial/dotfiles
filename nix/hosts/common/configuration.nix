{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  nativeCompatLibraries = with pkgs; [
    stdenv.cc.cc.lib
    zlib
    libGL
    glib
  ];
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
      "wheel"
      "networkmanager"
      "video"
    ];
    packages = with pkgs; [
      tree
    ];
  };

  programs.firefox.enable = true;
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
    builtins.elem (lib.getName pkg) [
      "nvidia-settings"
      "nvidia-x11"
      "obsidian"
      "spotify"
    ];
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
  ];

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
