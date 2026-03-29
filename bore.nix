{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.services.bore-server;
in {
  options.services.bore-server = with lib; {
    enable = lib.mkEnableOption "Bore self-hosted tunnel server";

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.bore-cli;
      description = "The bore-cli package to use.";
    };

    bindAddress = lib.mkOption {
      type = lib.types.str;
      default = "0.0.0.0";
      description = "IP address clients connect to the server at.";
    };

    minPort = lib.mkOption {
      type = lib.types.ints.between 1 65535;
      default = 1024;
      description = "Minimum TCP port for tunnels.";
    };

    maxPort = lib.mkOption {
      type = lib.types.ints.between 1 65535;
      default = 65535;
      description = "Maximum TCP port for tunnels.";
    };

    credentialsFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = "Path to file containing the authentication secret.";
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.bore-server = {
      description = "Bore Tunnel Server";
      after = ["network.target"];
      wantedBy = ["multi-user.target"];

      serviceConfig = {
        ExecStart = let
          secretEnv = lib.optionalString (cfg.credentialsFile != null) ''
            export BORE_SECRET=$(cat $CREDENTIALS_DIRECTORY/bore-secret)
          '';
        in "${pkgs.writeShellScript "bore-server" ''
          #!/usr/bin/env bash
          set -euo pipefail
          ${secretEnv}
          exec ${lib.getExe cfg.package} server 
            --bind-addr ${cfg.bindAddress} 
            --min-port ${toString cfg.minPort} 
            --max-port ${toString cfg.maxPort}
        ''}";
        Restart = "always";
        RestartSec = "5s";

        DynamicUser = true;
        RuntimeDirectory = "bore-server";
        CapabilityBoundingSet = ["CAP_NET_BIND_SERVICE"];
        AmbientCapabilities = ["CAP_NET_BIND_SERVICE"];
        NoNewPrivileges = true;
        PrivateTmp = true;
        ProtectSystem = "strict";
        ProtectHome = true;
        PrivateDevices = true;

        LoadCredential = lib.optionalString (cfg.credentialsFile != null) "bore-secret:${cfg.credentialsFile}";
      };
    };
  };
}
