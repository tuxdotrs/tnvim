{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.tux.services.cyber-tux;
in {
  options.tux.services.cyber-tux = {
    enable = mkEnableOption "Enable CyberTux Discord bot";

    user = mkOption {
      type = types.str;
      default = "cyber-tux";
      description = "User under which the CyberTux service runs.";
    };

    group = mkOption {
      type = types.str;
      default = "cyber-tux";
      description = "Group under which the CyberTux service runs.";
    };

    environmentFile = mkOption {
      type = types.path;
      description = "Environment file containing DISCORD_TOKEN";
    };
  };

  config = mkIf cfg.enable {
    systemd.services = {
      cyber-tux = {
        description = "A discord bot for my server";
        after = ["network.target"];
        wantedBy = ["multi-user.target"];

        serviceConfig = {
          Type = "simple";
          User = "cyber-tux";
          Group = "cyber-tux";
          EnvironmentFile = cfg.environmentFile;
          ExecStart = getExe pkgs.cyber-tux;
          Restart = "always";

          LockPersonality = true;
          MemoryDenyWriteExecute = true;
          NoNewPrivileges = true;
          PrivateDevices = true;
          PrivateIPC = true;
          PrivateTmp = true;
          PrivateUsers = true;
          ProtectClock = true;
          ProtectControlGroups = true;
          ProtectHome = true;
          ProtectHostname = true;
          ProtectKernelLogs = true;
          ProtectKernelModules = true;
          ProtectKernelTunables = true;
          ProtectProc = "invisible";
          ProtectSystem = "strict";
          RestrictNamespaces = "uts ipc pid user cgroup";
          RestrictRealtime = true;
          RestrictSUIDSGID = true;
          SystemCallArchitectures = "native";
          SystemCallFilter = ["@system-service"];
          UMask = "0077";
        };
      };
    };
    # Ensure the user and group exist
    users.users = mkIf (cfg.user == "cyber-tux") {
      ${cfg.user} = {
        isSystemUser = true;
        group = cfg.group;
        description = "CyberTux service user";
        home = "/var/lib/cyber-tux";
        createHome = true;
      };
    };

    users.groups = mkIf (cfg.group == "cyber-tux") {
      ${cfg.group} = {};
    };
  };
}
