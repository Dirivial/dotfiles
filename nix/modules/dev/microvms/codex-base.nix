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
  swapSize,
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
      age
      curl
      git
      jq
      nixfmt
      openssh
      postgresql_17
      python314
      ripgrep
      shellcheck
      sops
      ssh-to-age
      cups
      pkg-config
      prek
      tmux
      uv
      vim
      zsh
    ]
    ++ extraPackages;

  environment.variables = {
    CODEX_HOME = "${homeDirectory}/.codex";
    PIP_CACHE_DIR = "/var/cache/${userName}/pip";
    TMPDIR = "/var/tmp";
    UV_CACHE_DIR = "/var/cache/${userName}/uv";
    UV_LINK_MODE = "copy";
    UV_PYTHON = "${pkgs.python314}/bin/python";
    UV_PYTHON_DOWNLOADS = "never";
  };

  systemd.tmpfiles.rules = [
    "d /var/cache/${userName} 0700 ${userName} ${userName} -"
    "d /var/cache/${userName}/pip 0700 ${userName} ${userName} -"
    "d /var/cache/${userName}/uv 0700 ${userName} ${userName} -"
    "d /var/lib/nix-rw-store 0755 root root -"
    "d /var/tmp 1777 root root -"
  ];

  networking.hostName = hostName;
  networking.useDHCP = false;
  networking.useNetworkd = true;
  networking.tempAddresses = "disabled";
  networking.nameservers = [
    "1.1.1.1"
    "8.8.8.8"
  ];
  networking.firewall.enable = false;

  swapDevices = lib.optional (swapSize > 0) {
    device = "/var/lib/swapfile";
    size = swapSize;
  };

  nix.nixPath = [ "nixpkgs=${pkgs.path}" ];
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

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
    writableStoreOverlay = "/var/lib/nix-rw-store";
    volumes = [
      {
        mountPoint = "/var";
        image = "var-${name}.img";
        size = 16384;
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
