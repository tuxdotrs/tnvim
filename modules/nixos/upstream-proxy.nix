{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.tux.services.nginxStreamProxy;

  upstreamServerType = lib.types.submodule ({config, ...}: {
    options = {
      address = lib.mkOption {
        type = lib.types.str;
        description = "IP address or hostname of the upstream server";
      };
      port = lib.mkOption {
        type = lib.types.port;
        default = 9999;
        description = "Port number of the upstream server";
      };
      listenPort = lib.mkOption {
        type = lib.types.port;
        default = config.port;
        defaultText = lib.literalExpression "port";
        description = "Local port to listen for incoming connections (defaults to port)";
      };
    };
  });
in {
  options.tux.services.nginxStreamProxy = {
    enable = lib.mkEnableOption "Enable nginx TCP stream proxy";

    upstreamServers = lib.mkOption {
      type = lib.types.listOf upstreamServerType;
      default = [
        {
          address = "0.0.0.0";
          port = 9999;
        }
      ];
      description = "List of upstream servers to proxy to, each with its own listen port";
    };
  };

  config = lib.mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = map (server: server.listenPort) cfg.upstreamServers;

    services.nginx = {
      enable = lib.mkForce true;
      package = pkgs.nginx.override {withStream = true;};
      streamConfig =
        lib.concatMapStringsSep "\n" (server: ''
          server {
            listen ${toString server.listenPort};
            proxy_pass ${server.address}:${toString server.port};
          }
        '')
        cfg.upstreamServers;
    };
  };
}
