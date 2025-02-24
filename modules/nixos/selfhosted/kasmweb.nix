{lib, ...}: {
  services = {
    kasmweb = {
      enable = true;
      listenPort = 8843;
    };

    nginx = {
      enable = lib.mkForce true;
      virtualHosts = {
        "kasm.tux.rs" = {
          forceSSL = true;
          useACMEHost = "tux.rs";
          locations = {
            "/" = {
              proxyPass = "https://127.0.0.1:8843";
              proxyWebsockets = true;
            };
          };
        };
      };
    };
  };
}
