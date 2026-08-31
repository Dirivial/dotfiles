{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/dev/codex-microvms.nix
    ../../modules/services/desktop-homelab.nix
  ];

  alkade.desktopHomelab.enable = true;

  alkade.codexMicrovms = {
    enable = true;
    authorizedKeys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDCbqvnbXHoMUhKyC/RxG/cIhQvkxW3ERJoOM6mYjete alkade@alkade"
    ];

    vms.codex = {
      mem = 12288;
      vcpu = 12;
      swapSize = 8192;
      varSize = 65536;
      vsockCid = 10;
      workspace = "/home/alkade/workspace";
      ipAddress = "192.168.83.10";
      tapId = "microvm10";
      mac = "02:00:00:00:10:10";
    };
  };

  programs.steam.enable = true;
  programs.gamescope.enable = true;

  # Ada Lovelace desktop GPU.  The RTX 4080 is supported by Nvidia's open
  # kernel module; the proprietary user-space driver is still used.
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
  hardware.nvidia = {
    open = true;
    modesetting.enable = true;
    package = config.boot.kernelPackages.nvidiaPackages.production;
  };

  system.stateVersion = "26.05";
}
