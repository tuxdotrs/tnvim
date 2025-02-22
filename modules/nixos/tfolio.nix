{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.tux.services.tfolio;
in {
  options.tux.services.tfolio = {
    enable = mkEnableOption "Enable tfolio";

    host = mkOption {
      type = lib.types.str;
      default = "0.0.0.0";
      description = "";
    };

    port = mkOption {
      type = lib.types.port;
      default = 22;
      description = "";
    };

    dataDir = mkOption {
      type = lib.types.str;
      default = "/var/lib/tfolio/";
      description = "";
    };

    user = mkOption {
      type = types.str;
      default = "tfolio";
      description = "User under which the tfolio service runs.";
    };

    group = mkOption {
      type = types.str;
      default = "tfolio";
      description = "Group under which the tfolio service runs.";
    };
  };

  config = mkIf cfg.enable {
    systemd.services = {
      tfolio = {
        description = "my portfolio in a ssh session";
        after = ["network.target"];
        wantedBy = ["multi-user.target"];

        serviceConfig = {
          Type = "simple";
          User = cfg.user;
          Group = cfg.group;
          ExecStart = "${getExe pkgs.tfolio} -l ${cfg.host} -p ${toString cfg.port} -d ${cfg.dataDir}";
          Restart = "always";
          StateDirectory = "tfolio";

          # Allow binding to privileged ports
          AmbientCapabilities = "CAP_NET_BIND_SERVICE";
          CapabilityBoundingSet = "CAP_NET_BIND_SERVICE";

          LockPersonality = true;
          MemoryDenyWriteExecute = true;
          NoNewPrivileges = true;
          PrivateDevices = true;
          PrivateIPC = true;
          PrivateTmp = true;
          ProtectClock = true;
          ProtectControlGroups = true;
          ProtectHome = "read-only";
          ProtectHostname = true;
          ProtectKernelLogs = true;
          ProtectKernelModules = true;
          ProtectKernelTunables = true;
          ProtectProc = "invisible";
          ProtectSystem = "full";
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
    users.users = mkIf (cfg.user == "tfolio") {
      ${cfg.user} = {
        isSystemUser = true;
        group = cfg.group;
        description = "tfolio service user";
        home = "/var/lib/tfolio";
        createHome = true;
      };
    };

    users.groups = mkIf (cfg.group == "tfolio") {
      ${cfg.group} = {};
    };
  };
}
