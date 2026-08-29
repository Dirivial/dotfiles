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
  ];

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
