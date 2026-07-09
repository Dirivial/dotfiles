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
    authorizedKeys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKo63H0TZ3h0nxjwkzUrsUD0Y1COYjyroq9D73Ym9bNQ alkade@alkade"
    ];

    # Before starting this VM, generate its host key manually:
    # mkdir -p /home/alkade/microvm/codex/ssh-host-keys
    # ssh-keygen -t ed25519 -N "" -f /home/alkade/microvm/codex/ssh-host-keys/ssh_host_ed25519_key
    vms.codex = {
      vsockCid = 10;
      workspace = "/home/alkade/microvm/codex";
      ipAddress = "192.168.83.10";
      tapId = "microvm10";
      mac = "02:00:00:00:10:10";
    };
  };

  # Note: Research before changing this
  system.stateVersion = "25.11";
}
