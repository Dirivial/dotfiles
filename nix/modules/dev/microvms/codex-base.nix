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
  sshHostKeysDirectory,
  stateVersion,
  swapSize,
  tapId,
  uid,
  userName,
  varSize,
  vcpu,
  vsockCid,
  workspace,
}:
{ lib, pkgs, ... }:
let
  homeDirectory = "/home/${userName}";
  codexDefaultHome = "${homeDirectory}/.codex";
  codexAccountsDir = "${codexDefaultHome}/accounts";
  codexActiveFile = "${codexDefaultHome}/active-account";
  codexAccountEnv = ''
    export CODEX_ACCOUNT_ACTIVE_FILE=${lib.escapeShellArg codexActiveFile}
    export CODEX_PERSONAL_HOME=${lib.escapeShellArg codexDefaultHome}
    export CODEX_WORK_HOME=${lib.escapeShellArg "${codexAccountsDir}/work"}
    export CODEX_ACCOUNTS_DIR=${lib.escapeShellArg codexAccountsDir}
    export CODEX_BASE_CONFIG=${lib.escapeShellArg "${codexDefaultHome}/config.toml"}
  '';
  codexAccount = pkgs.writeShellApplication {
    name = "codex-account";
    runtimeInputs = [ pkgs.coreutils ];
    text = builtins.readFile ../../../../scripts/codex-account;
  };
  codexWithBypass = pkgs.writeShellScriptBin "codex" ''
    set -euo pipefail

    default_codex_home=${lib.escapeShellArg codexDefaultHome}
    if [ -z "''${CODEX_HOME:-}" ] || [ "''${CODEX_HOME:-}" = "$default_codex_home" ]; then
      ${codexAccountEnv}
      account="$(${codexAccount}/bin/codex-account current 2>/dev/null || printf '%s\n' personal)"
      CODEX_HOME="$(${codexAccount}/bin/codex-account init "$account")"
      export CODEX_HOME
    fi

    exec ${pkgs.codex}/bin/codex --dangerously-bypass-approvals-and-sandbox -c 'cli_auth_credentials_store="file"' "$@"
  '';
  nativeCompatLibraries = with pkgs; [
    stdenv.cc.cc.lib
    zlib
    libGL
    glib
  ];
  nativeCompatLibraryPath = lib.makeLibraryPath nativeCompatLibraries;
in
{
  environment.systemPackages =
    with pkgs;
    [
      codexWithBypass
      codexAccount
      age
      curl
      gcc
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
      cups.dev
      cups.lib
      pkg-config
      prek
      tmux
      uv
      vim
      zsh
    ]
    ++ extraPackages;

  programs.nix-ld = {
    enable = true;
    libraries = nativeCompatLibraries;
  };

  environment.variables = {
    CFLAGS = "-I${pkgs.cups.dev}/include";
    C_INCLUDE_PATH = "${pkgs.cups.dev}/include";
    CODEX_ACCOUNT_ACTIVE_FILE = codexActiveFile;
    CODEX_ACCOUNTS_DIR = codexAccountsDir;
    CODEX_BASE_CONFIG = "${codexDefaultHome}/config.toml";
    CODEX_HOME = codexDefaultHome;
    CODEX_PERSONAL_HOME = codexDefaultHome;
    CODEX_WORK_HOME = "${codexAccountsDir}/work";
    CPPFLAGS = "-I${pkgs.cups.dev}/include";
    LDFLAGS = "-L${pkgs.cups.lib}/lib -Wl,-rpath,${pkgs.cups.lib}/lib";
    LD_LIBRARY_PATH = nativeCompatLibraryPath;
    LIBRARY_PATH = "${pkgs.cups.lib}/lib";
    PKG_CONFIG_PATH = "${pkgs.cups.dev}/lib/pkgconfig";
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
      ${codexAccountEnv}
      codex_account_current="$(codex-account current 2>/dev/null || printf '%s\n' personal)"
      export CODEX_HOME="$(codex-account init "$codex_account_current")"
      export PNPM_HOME="$HOME/.local/share/pnpm"

      export EDITOR="vim"
      path+=("$PNPM_HOME" "$HOME/go/bin")

      eval "$(codex-account shell-init)"

      PROMPT="%F{red}[MICROVM:${hostName}]%f $PROMPT"

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
        size = varSize;
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
        source = sshHostKeysDirectory;
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
