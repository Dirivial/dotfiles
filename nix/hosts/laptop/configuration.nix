{ config, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  # Note: Research before changing this
  system.stateVersion = "25.11";
}

