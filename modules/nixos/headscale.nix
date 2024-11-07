{
  config,
  pkgs,
  lib,
  email,
  ...
}: {
  security = {
    acme = {
      defaults.email = "${email}";
      acceptTerms = true;
    };
  };

  services = {
    headscale = {
      enable = true;
      port = 8080;
      address = "0.0.0.0";
      settings = {
        dns = {
          base_domain = "hs.tux.rs";
          search_domains = ["tux.rs"];
          magic_dns = true;
          nameservers.global = [
            "9.9.9.9"
          ];
        };
        # server_url = "https://hs.tux.rs:443";
        metrics_listen_addr = "0.0.0.0:8095";
        logtail = {
          enabled = false;
        };
        log = {
          level = "warn";
        };
        ip_prefixes = [
          "100.64.0.0/10"
          "fd7a:115c:a1e0::/48"
        ];
      };
    };

    nginx = {
      enable = lib.mkForce true;
      virtualHosts = {
        "hs.tux.rs" = {
          forceSSL = true;
          useACMEHost = "tux.rs";
          locations = {
            "/" = {
              proxyPass = "http://localhost:${toString config.services.headscale.port}";
              proxyWebsockets = true;
            };
            "/metrics" = {
              proxyPass = "http://${config.services.headscale.settings.metrics_listen_addr}/metrics";
            };
          };
        };
      };
    };
  };

  environment.systemPackages = with pkgs; [headscale];
}
