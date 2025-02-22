{
  config,
  lib,
  ...
}: {
  services = {
    plausible = {
      enable = true;

      server = {
        baseUrl = "https://plausible.tux.rs";
        port = 2100;
        disableRegistration = true;
        secretKeybaseFile = config.sops.secrets.plausible_key.path;
      };

      database.postgres = {
        dbname = "plausible";
        socket = "/run/postgresql";
      };
    };

    nginx = {
      enable = lib.mkForce true;
      virtualHosts = {
        "plausible.tux.rs" = {
          forceSSL = true;
          useACMEHost = "tux.rs";
          locations = {
            "/" = {
              proxyPass = "http://localhost:2100";
              proxyWebsockets = true;
            };
          };
        };
      };
    };
  };
}
