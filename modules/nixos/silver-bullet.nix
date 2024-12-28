{
  lib,
  config,
  ...
}: {
  services = {
    silverbullet = {
      enable = true;
      listenPort = 9876;
      envFile = config.sops.secrets.silver_bullet.path;
    };

    nginx = {
      enable = lib.mkForce true;
      virtualHosts = {
        "notes.tux.rs" = {
          forceSSL = true;
          useACMEHost = "tux.rs";
          locations = {
            "/" = {
              proxyPass = "http://localhost:9876";
            };
          };
        };
      };
    };
  };
}
