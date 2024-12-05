{
  modulesPath,
  inputs,
  username,
  lib,
  email,
  config,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    (modulesPath + "/profiles/qemu-guest.nix")
    inputs.disko.nixosModules.default
    (import ./disko.nix {device = "/dev/sda";})

    ../common
    ../../modules/nixos/postgresql.nix
    ../../modules/nixos/headscale.nix
    ../../modules/nixos/vaultwarden.nix
    ../../modules/nixos/gitea.nix
    ../../modules/nixos/plausible.nix
    ../../modules/nixos/monitoring/grafana.nix
    ../../modules/nixos/monitoring/loki.nix
    ../../modules/nixos/monitoring/promtail.nix
    ../../modules/nixos/ntfy-sh.nix
    ../../modules/nixos/searx.nix
    ../../modules/nixos/wakapi.nix
    ../../modules/nixos/nextcloud.nix
  ];

  sops.secrets = {
    borg_encryption_key = {
      sopsFile = ./secrets.yaml;
    };

    searx_secret_key = {
      sopsFile = ./secrets.yaml;
    };

    "cloudflare_credentials/email" = {
      sopsFile = ./secrets.yaml;
    };

    "cloudflare_credentials/dns_api_token" = {
      sopsFile = ./secrets.yaml;
    };

    plausible_key = {
      sopsFile = ./secrets.yaml;
    };

    wakapi_salt = {
      sopsFile = ./secrets.yaml;
    };

    nextcloud_password = {
      sopsFile = ./secrets.yaml;
      owner = "nextcloud";
    };
  };

  nixpkgs = {
    hostPlatform = "x86_64-linux";
  };

  boot = {
    kernel.sysctl = {
      "vm.swappiness" = 10;
    };

    initrd.systemd = {
      enable = lib.mkForce true;

      services.wipe-my-fs = {
        wantedBy = ["initrd.target"];
        after = ["initrd-root-device.target"];
        before = ["sysroot.mount"];
        unitConfig.DefaultDependencies = "no";
        serviceConfig.Type = "oneshot";
        script = ''
          mkdir /btrfs_tmp
          mount /dev/disk/by-partlabel/disk-primary-root /btrfs_tmp

          if [[ -e /btrfs_tmp/root ]]; then
              mkdir -p /btrfs_tmp/old_roots
              timestamp=$(date --date="@$(stat -c %Y /btrfs_tmp/root)" "+%Y-%m-%-d_%H:%M:%S")
              mv /btrfs_tmp/root "/btrfs_tmp/old_roots/$timestamp"
          fi

          delete_subvolume_recursively() {
              IFS=$'\n'
              for i in $(btrfs subvolume list -o "$1" | cut -f 9- -d ' '); do
                  delete_subvolume_recursively "/btrfs_tmp/$i"
              done
              btrfs subvolume delete "$1"
          }

          for i in $(find /btrfs_tmp/old_roots/ -maxdepth 1 -mtime +30); do
              delete_subvolume_recursively "$i"
          done

          btrfs subvolume create /btrfs_tmp/root
          umount /btrfs_tmp
        '';
      };
    };

    loader = {
      grub = {
        efiSupport = true;
        efiInstallAsRemovable = true;
        configurationLimit = 10;
      };
      timeout = 1;
    };
  };

  networking = {
    hostName = "arcturus";

    firewall = {
      enable = true;
      allowedTCPPorts = [80 443 22 3333];
    };
  };

  security = {
    sudo.wheelNeedsPassword = false;

    acme = {
      acceptTerms = true;
      defaults.email = "${email}";
      certs = {
        "tux.rs" = {
          group = "nginx";
          domain = "*.tux.rs";
          extraDomainNames = ["tux.rs"];
          dnsProvider = "cloudflare";
          credentialFiles = {
            CLOUDFLARE_EMAIL_FILE = config.sops.secrets."cloudflare_credentials/email".path;
            CLOUDFLARE_DNS_API_TOKEN_FILE = config.sops.secrets."cloudflare_credentials/dns_api_token".path;
          };
        };
      };
    };
  };

  users.users.nginx.extraGroups = ["acme"];

  services = {
    nginx = {
      recommendedTlsSettings = true;
      recommendedBrotliSettings = true;
      recommendedOptimisation = true;
      recommendedGzipSettings = true;
      recommendedProxySettings = true;
      recommendedZstdSettings = true;
    };

    borgbackup.jobs.arcturus-backup = {
      paths = [
        "/persist/home"
        "/persist/etc"
        "/persist/var/lib/headscale"
        "/persist/var/lib/vaultwarden"
        "/persist/var/lib/gitea"
        "/persist/var/lib/grafana"
        "/persist/var/lib/promtail"
        "/persist/var/lib/private"
        "/persist/var/lib/nextcloud"
      ];
      encryption = {
        mode = "repokey-blake2";
        passCommand = "cat ${config.sops.secrets.borg_encryption_key.path}";
      };
      environment.BORG_RSH = "ssh -i /home/${username}/.ssh/storagebox";
      repo = "ssh://u416910@u416910.your-storagebox.de:23/./arcturus-backups";
      compression = "auto,zstd";
      startAt = "daily";
    };
  };

  programs.fuse.userAllowOther = true;
  fileSystems."/persist".neededForBoot = true;
  environment.persistence."/persist" = {
    hideMounts = true;
    directories = [
      "/var/log"
      "/var/lib/nixos"
      "/var/lib/acme"
      "/var/lib/postgresql"
      "/var/lib/headscale"
      "/var/lib/vaultwarden"
      "/var/lib/gitea"
      "/var/lib/clickhouse"
      "/var/lib/grafana"
      "/var/lib/promtail"
      "/var/lib/private"
      "/var/lib/nextcloud"
    ];
    files = [
      "/etc/ssh/ssh_host_ed25519_key"
      "/etc/ssh/ssh_host_ed25519_key.pub"
      "/etc/ssh/ssh_host_rsa_key"
      "/etc/ssh/ssh_host_rsa_key.pub"
    ];
  };

  home-manager.users.${username} = {
    imports = [
      ./home.nix
    ];
  };

  system.stateVersion = "24.11";
}
