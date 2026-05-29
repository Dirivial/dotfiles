{ config, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  networking.firewall.allowedTCPPorts = [ 53317 ];
  networking.firewall.allowedUDPPorts = [ 53317 ];

  services.tailscale = {
    enable = true;
    openFirewall = true;
  };

  # Note: Research before changing this
  system.stateVersion = "25.11";
}
