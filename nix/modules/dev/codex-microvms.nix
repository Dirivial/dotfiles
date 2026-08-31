{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.alkade.codexMicrovms;

  vmOptions =
    { name, ... }:
    {
      options = {
        autostart = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Start this Codex microVM at boot.";
        };

        workspace = lib.mkOption {
          type = lib.types.str;
          description = "Host workspace directory shared into the microVM.";
        };

        ipAddress = lib.mkOption {
          type = lib.types.str;
          description = "Static IPv4 address assigned to the microVM.";
        };

        tapId = lib.mkOption {
          type = lib.types.str;
          default = "microvm-${name}";
          description = "Host TAP interface name for the microVM.";
        };

        mac = lib.mkOption {
          type = lib.types.str;
          description = "Static MAC address assigned to the microVM interface.";
        };

        mem = lib.mkOption {
          type = lib.types.ints.positive;
          default = cfg.defaultMem;
          description = "Memory in MiB assigned to the microVM.";
        };

        swapSize = lib.mkOption {
          type = lib.types.ints.unsigned;
          default = cfg.defaultSwapSize;
          description = "Swapfile size in MiB configured inside the microVM. Set to 0 to disable swap.";
        };

        varSize = lib.mkOption {
          type = lib.types.ints.positive;
          default = cfg.defaultVarSize;
          description = "Persistent /var volume size in MiB for the microVM.";
        };

        vcpu = lib.mkOption {
          type = lib.types.ints.positive;
          default = cfg.defaultVcpu;
          description = "vCPU count assigned to the microVM.";
        };

        vsockCid = lib.mkOption {
          type = lib.types.ints.positive;
          description = "Unique virtio-vsock context ID assigned to the microVM.";
        };

        extraPackages = lib.mkOption {
          type = lib.types.listOf lib.types.package;
          default = [ ];
          description = "Additional packages installed inside this microVM.";
        };

        extraShellInit = lib.mkOption {
          type = lib.types.lines;
          default = "";
          description = "Extra shell initialization for the microVM user.";
        };
      };
    };

  mkVmConfig = name: vm: {
    autostart = vm.autostart;
    config = {
      imports = [
        inputs.microvm.nixosModules.microvm
        (import ./microvms/codex-base.nix {
          inherit name;
          authorizedKeys = cfg.authorizedKeys;
          bridgeGateway = cfg.bridgeAddress;
          codexStateDirectory = cfg.codexStateDirectory;
          hostName = name;
          hypervisor = cfg.hypervisor;
          stateVersion = cfg.stateVersion;
          sshHostKeysDirectory = "/home/${cfg.userName}/.local/state/microvm/${name}/ssh-host-keys";
          userName = cfg.userName;
          inherit (cfg) gid uid;
          inherit (vm)
            extraPackages
            extraShellInit
            ipAddress
            mac
            mem
            swapSize
            tapId
            varSize
            vcpu
            vsockCid
            workspace
            ;
        })
      ];
    };
  };
in
{
  imports = [ inputs.microvm.nixosModules.host ];

  options.alkade.codexMicrovms = {
    enable = lib.mkEnableOption "Codex microVMs for isolated coding-agent sessions";

    bridgeName = lib.mkOption {
      type = lib.types.str;
      default = "microbr";
      description = "Bridge interface used by Codex microVM TAP devices.";
    };

    bridgeAddress = lib.mkOption {
      type = lib.types.str;
      default = "192.168.83.1";
      description = "IPv4 address assigned to the host-side microVM bridge.";
    };

    bridgePrefixLength = lib.mkOption {
      type = lib.types.ints.between 1 32;
      default = 24;
      description = "IPv4 prefix length for the microVM bridge network.";
    };

    externalInterface = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "Host network interface used for NAT egress from microVMs, or null to masquerade through the active default route.";
    };

    userName = lib.mkOption {
      type = lib.types.str;
      default = "alkade";
      description = "User account created inside Codex microVMs.";
    };

    uid = lib.mkOption {
      type = lib.types.ints.unsigned;
      default = 1000;
      description = "UID for the microVM user.";
    };

    gid = lib.mkOption {
      type = lib.types.ints.unsigned;
      default = 1000;
      description = "GID for the microVM user group.";
    };

    authorizedKeys = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "SSH public keys authorized for the microVM user.";
    };

    codexStateDirectory = lib.mkOption {
      type = lib.types.str;
      default = "/home/${cfg.userName}/.local/state/codex-microvm";
      description = "Host directory mounted as the microVM user's CODEX_HOME.";
    };

    hostCodexDirectory = lib.mkOption {
      type = lib.types.str;
      default = "/home/${cfg.userName}/.codex";
      description = "Host Codex state directory used to seed auth/config into MicroVM CODEX_HOME.";
    };

    defaultMem = lib.mkOption {
      type = lib.types.ints.positive;
      default = 8192;
      description = "Default memory in MiB assigned to each Codex microVM.";
    };

    defaultSwapSize = lib.mkOption {
      type = lib.types.ints.unsigned;
      default = 4096;
      description = "Default swapfile size in MiB configured inside each Codex microVM. Set to 0 to disable swap.";
    };

    defaultVarSize = lib.mkOption {
      type = lib.types.ints.positive;
      default = 65536;
      description = "Default persistent /var volume size in MiB for each Codex microVM.";
    };

    defaultVcpu = lib.mkOption {
      type = lib.types.ints.positive;
      default = 8;
      description = "Default vCPU count assigned to each Codex microVM.";
    };

    hypervisor = lib.mkOption {
      type = lib.types.enum [
        "cloud-hypervisor"
        "qemu"
        "firecracker"
      ];
      default = "cloud-hypervisor";
      description = "microvm.nix hypervisor backend.";
    };

    stateVersion = lib.mkOption {
      type = lib.types.str;
      default = config.system.stateVersion;
      description = "NixOS state version used inside Codex microVM guests.";
    };

    vms = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule vmOptions);
      default = { };
      description = "Codex microVM definitions keyed by VM name.";
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.vms != { };
        message = "alkade.codexMicrovms.enable requires at least one alkade.codexMicrovms.vms entry.";
      }
    ];

    systemd.network.enable = true;
    systemd.network.netdevs."20-${cfg.bridgeName}".netdevConfig = {
      Kind = "bridge";
      Name = cfg.bridgeName;
    };

    systemd.network.networks."20-${cfg.bridgeName}" = {
      matchConfig.Name = cfg.bridgeName;
      addresses = [
        {
          Address = "${cfg.bridgeAddress}/${toString cfg.bridgePrefixLength}";
        }
      ];
      networkConfig.ConfigureWithoutCarrier = true;
    };

    systemd.network.networks."21-microvm-tap" = {
      matchConfig.Name = "microvm*";
      networkConfig.Bridge = cfg.bridgeName;
    };

    networking.nat = {
      enable = true;
      internalInterfaces = [ cfg.bridgeName ];
      externalInterface = cfg.externalInterface;
    };

    networking.extraHosts = lib.concatStringsSep "\n" (
      lib.mapAttrsToList (name: vm: "${vm.ipAddress} ${name}.microvm") cfg.vms
    );

    systemd.services = lib.mapAttrs' (
      name: vm:
      let
        sshHostKeysDirectory = "/home/${cfg.userName}/.local/state/microvm/${name}/ssh-host-keys";
      in
      lib.nameValuePair "microvm-virtiofsd@${name}" {
        preStart = lib.mkBefore ''
          install -d -m 0700 -o ${toString cfg.uid} -g ${toString cfg.gid} ${cfg.codexStateDirectory}
          install -d -m 0755 -o ${toString cfg.uid} -g ${toString cfg.gid} ${vm.workspace}
          if [ -e ${cfg.hostCodexDirectory}/auth.json ] && [ ! -e ${cfg.codexStateDirectory}/auth.json ]; then
            install -m 0600 -o ${toString cfg.uid} -g ${toString cfg.gid} ${cfg.hostCodexDirectory}/auth.json ${cfg.codexStateDirectory}/auth.json
          fi
          install -d -m 0700 -o ${toString cfg.uid} -g ${toString cfg.gid} ${cfg.codexStateDirectory}/accounts/work
          if [ -e /home/${cfg.userName}/.codex-work/auth.json ] && [ ! -e ${cfg.codexStateDirectory}/accounts/work/auth.json ]; then
            install -m 0600 -o ${toString cfg.uid} -g ${toString cfg.gid} /home/${cfg.userName}/.codex-work/auth.json ${cfg.codexStateDirectory}/accounts/work/auth.json
          fi
          if [ -e ${cfg.hostCodexDirectory}/config.toml ] && [ ! -e ${cfg.codexStateDirectory}/config.toml ]; then
            install -m 0600 -o ${toString cfg.uid} -g ${toString cfg.gid} ${cfg.hostCodexDirectory}/config.toml ${cfg.codexStateDirectory}/config.toml
          fi
          if [ ! -e ${sshHostKeysDirectory}/ssh_host_ed25519_key ]; then
            echo "Missing SSH host key for MicroVM ${name}: ${sshHostKeysDirectory}/ssh_host_ed25519_key" >&2
            echo "Generate it manually with: mkdir -p ${sshHostKeysDirectory}" >&2
            echo "Then run: ssh-keygen -t ed25519 -N "" -f ${sshHostKeysDirectory}/ssh_host_ed25519_key" >&2
            exit 1
          fi
        '';
      }
    ) cfg.vms;

    microvm.vms = lib.mapAttrs mkVmConfig cfg.vms;
  };
}
