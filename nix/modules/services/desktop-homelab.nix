{ config, lib, pkgs, ... }:

let
  cfg = config.alkade.desktopHomelab;
  sttUser = "wyoming-faster-whisper";
in
{
  options.alkade.desktopHomelab = {
    enable = lib.mkEnableOption "desktop homelab services";

    homeAssistantAddress = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      example = "192.168.1.20";
      description = "Static LAN address of the Home Assistant Raspberry Pi. Until set, its desktop service ports remain blocked by the firewall.";
    };
  };

  config = lib.mkIf cfg.enable {
    services.tailscale = {
      enable = true;
      openFirewall = true;
    };

    services.syncthing = {
      enable = true;
      user = "alkade";
      group = "users";
      dataDir = "/home/alkade";
      configDir = "/home/alkade/.config/syncthing";
      guiAddress = "127.0.0.1:8384";
      openDefaultPorts = true;
      overrideDevices = false;
      overrideFolders = false;
    };

    virtualisation.docker.enable = true;
    hardware.nvidia-container-toolkit.enable = true;

    services.ollama = {
      enable = true;
      package = pkgs.ollama-cuda;
      host = "127.0.0.1";
      port = 11434;
      loadModels = [ "qwen3:8b" ];
      syncModels = false;
    };

    users.users.${sttUser} = {
      isSystemUser = true;
      group = sttUser;
      extraGroups = [ "video" "render" ];
    };
    users.groups.${sttUser} = { };

    systemd.services.wyoming-faster-whisper = {
      description = "GPU-backed Wyoming Faster Whisper server";
      wantedBy = [ "multi-user.target" ];
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];
      serviceConfig = {
        User = sttUser;
        Group = sttUser;
        StateDirectory = "wyoming-faster-whisper";
        ExecStart = "${lib.getExe pkgs.wyoming-faster-whisper} --uri tcp://0.0.0.0:10300 --model Systran/faster-distil-whisper-large-v3 --compute-type int8_float16 --device cuda --data-dir /var/lib/wyoming-faster-whisper --download-dir /var/lib/wyoming-faster-whisper";
        Restart = "on-failure";
        RestartSec = "5s";
        NoNewPrivileges = true;
        PrivateTmp = true;
        ProtectHome = true;
        ProtectSystem = "strict";
        ReadWritePaths = [ "/var/lib/wyoming-faster-whisper" ];
      };
    };

    systemd.tmpfiles.rules = [
      "d /srv/immich 0750 immich immich -"
      "d /srv/immich/library 0750 immich immich -"
    ];

    services.immich = {
      enable = true;
      host = "0.0.0.0";
      port = 2283;
      mediaLocation = "/srv/immich/library";
      secretsFile = "/etc/immich/immich.env";
      machine-learning.enable = false;
    };

    environment.etc."litellm/config.yaml".text = ''
      model_list:
        - model_name: qwen
          litellm_params:
            model: ollama/qwen3:8b
            api_base: http://127.0.0.1:11434
      general_settings:
        master_key: os.environ/LITELLM_MASTER_KEY
    '';

    users.users.litellm = {
      isSystemUser = true;
      group = "litellm";
    };
    users.groups.litellm = { };

    systemd.services.litellm = {
      description = "Authenticated OpenAI-compatible proxy for local Ollama";
      wantedBy = [ "multi-user.target" ];
      after = [ "network-online.target" "ollama.service" ];
      wants = [ "network-online.target" "ollama.service" ];
      unitConfig.ConditionPathExists = "/etc/litellm/litellm.env";
      serviceConfig = {
        User = "litellm";
        Group = "litellm";
        EnvironmentFile = "/etc/litellm/litellm.env";
        ExecStart = "${lib.getExe pkgs.litellm} --config /etc/litellm/config.yaml --host 0.0.0.0 --port 4000";
        Restart = "on-failure";
        RestartSec = "5s";
        NoNewPrivileges = true;
        PrivateTmp = true;
        ProtectHome = true;
        ProtectSystem = "strict";
      };
    };

    networking.firewall.extraInputRules = lib.mkIf (cfg.homeAssistantAddress != null) ''
      ip saddr ${cfg.homeAssistantAddress} tcp dport { 10300, 4000, 2283 } accept
    '';
  };
}
