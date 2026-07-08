{ config, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/dev/codex-microvms.nix
  ];

  networking.firewall.allowedTCPPorts = [ 53317 ];
  networking.firewall.allowedUDPPorts = [ 53317 ];

  services.tailscale = {
    enable = true;
    openFirewall = true;
  };

  alkade.codexMicrovms = {
    enable = true;
    externalInterface = "wlp2s0";
    authorizedKeys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKo63H0TZ3h0nxjwkzUrsUD0Y1COYjyroq9D73Ym9bNQ alkade@alkade"
    ];

    vms.codex = {
      workspace = "/home/alkade/microvm/codex";
      ipAddress = "192.168.83.10";
      tapId = "microvm10";
      mac = "02:00:00:00:10:10";
    };
  };

  # Note: Research before changing this
  system.stateVersion = "25.11";
}
