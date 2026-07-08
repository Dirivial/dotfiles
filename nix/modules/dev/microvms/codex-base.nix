{
  authorizedKeys,
  bridgeGateway,
  codexStateDirectory,
  extraPackages,
  extraShellInit,
  gid,
  hostName,
  hypervisor,
  ipAddress,
  mac,
  mem,
  name,
  stateVersion,
  tapId,
  uid,
  userName,
  vcpu,
  vsockCid,
  workspace,
}:
{ lib, pkgs, ... }:
let
  homeDirectory = "/home/${userName}";
  codexWithBypass = pkgs.writeShellScriptBin "codex" ''
    exec ${pkgs.codex}/bin/codex --dangerously-bypass-approvals-and-sandbox "$@"
  '';
in
{
  environment.systemPackages =
    with pkgs;
    [
      codexWithBypass
      git
      openssh
      ripgrep
      tmux
      vim
      zsh
    ]
    ++ extraPackages;

  environment.variables.CODEX_HOME = "${homeDirectory}/.codex";

  networking.hostName = hostName;
  networking.useDHCP = false;
  networking.useNetworkd = true;
  networking.tempAddresses = "disabled";
  networking.nameservers = [
    "1.1.1.1"
    "8.8.8.8"
  ];
  networking.firewall.enable = false;

  system.stateVersion = stateVersion;
  systemd.network.enable = true;
  systemd.network.networks."10-microvm" = {
    matchConfig.Name = "e*";
    addresses = [
      {
        Address = "${ipAddress}/24";
      }
    ];
    routes = [
      {
        Gateway = bridgeGateway;
      }
    ];
  };

  services.openssh = {
    enable = true;
    hostKeys = [
      {
        path = "/etc/ssh/host-keys/ssh_host_ed25519_key";
        type = "ed25519";
      }
    ];
  };
  services.resolved.enable = true;

  users.groups.${userName}.gid = gid;
  users.users.${userName} = {
    inherit uid;
    group = userName;
    home = homeDirectory;
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    shell = pkgs.zsh;
    openssh.authorizedKeys.keys = authorizedKeys;
  };
  security.sudo.wheelNeedsPassword = false;
  programs.zsh = {
    enable = true;
    ohMyZsh = {
      enable = true;
      theme = "crunch";
      plugins = [
        "git"
        "tmux"
      ];
      custom = "${pkgs.oh-my-zsh}/share/oh-my-zsh/custom";
    };
    shellInit = ''
      export CODEX_HOME=${homeDirectory}/.codex
      export PNPM_HOME="$HOME/.local/share/pnpm"

      export EDITOR="vim"
      path+=("$PNPM_HOME" "$HOME/go/bin")

      if [[ -f "$HOME/.local/bin/env" ]]; then
        . "$HOME/.local/bin/env"
      fi

      if [ "$USER" = ${lib.escapeShellArg userName} ] && [ -d ${lib.escapeShellArg workspace} ]; then
        cd ${lib.escapeShellArg workspace}
      fi

      ${extraShellInit}
    '';
  };

  systemd.settings.Manager.DefaultTimeoutStopSec = "5s";
  systemd.mounts = [
    {
      what = "store";
      where = "/nix/store";
      overrideStrategy = "asDropin";
      unitConfig.DefaultDependencies = false;
    }
  ];

  microvm = {
    writableStoreOverlay = "/nix/.rw-store";
    volumes = [
      {
        mountPoint = "/var";
        image = "var-${name}.img";
        size = 8192;
      }
    ];
    shares = [
      {
        proto = "virtiofs";
        tag = "ro-store";
        source = "/nix/store";
        mountPoint = "/nix/.ro-store";
      }
      {
        proto = "virtiofs";
        tag = "ssh-keys-${name}";
        source = "${workspace}/ssh-host-keys";
        mountPoint = "/etc/ssh/host-keys";
      }
      {
        proto = "virtiofs";
        tag = "codex-state-${name}";
        source = codexStateDirectory;
        mountPoint = "${homeDirectory}/.codex";
      }
      {
        proto = "virtiofs";
        tag = "workspace-${name}";
        source = workspace;
        mountPoint = workspace;
      }
    ];
    interfaces = [
      {
        type = "tap";
        id = tapId;
        inherit mac;
      }
    ];
    inherit hypervisor mem vcpu;
    vsock.cid = vsockCid;
    socket = "control.socket";
  };
}
