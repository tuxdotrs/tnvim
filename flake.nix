{
  description = "tux's NixOS Flake";

  outputs = {
    self,
    nixpkgs,
    deploy-rs,
    ...
  } @ inputs: let
    inherit (self) outputs;
    inherit (inputs.nixpkgs.lib) nixosSystem;
    forAllSystems = nixpkgs.lib.genAttrs [
      "x86_64-linux"
      "aarch64-linux"
    ];
    username = "tux";
    email = "t@tux.rs";

    mkNixOSConfig = host: {
      specialArgs = {inherit inputs outputs username email;};
      modules = [./hosts/${host}];
    };

    mkNode = hostname: {
      inherit hostname;
      profiles.system = {
        user = "root";
        path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.${hostname};
      };
    };
  in {
    packages = forAllSystems (system: import ./pkgs nixpkgs.legacyPackages.${system});
    formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);

    # Custom packages and modifications, exported as overlays
    overlays = import ./overlays {inherit inputs;};

    # NixOS configuration entrypoint
    # 'nixos-rebuild switch --flake .#your-hostname'
    nixosConfigurations = {
      arcturus = nixosSystem (mkNixOSConfig "arcturus");
      canopus = nixosSystem (mkNixOSConfig "canopus");
      alpha = nixosSystem (mkNixOSConfig "alpha");
      sirius = nixosSystem (mkNixOSConfig "sirius");
      vega = nixosSystem (mkNixOSConfig "vega");
      capella = nixosSystem (mkNixOSConfig "capella");
      vps = nixosSystem (mkNixOSConfig "vps");
      isoImage = nixosSystem (mkNixOSConfig "isoImage");
      homelab = nixosSystem (mkNixOSConfig "homelab");
    };

    deploy = {
      nodes = {
        arcturus = mkNode "arcturus";
        canopus = mkNode "canopus";
        alpha = mkNode "alpha";
        sirius = mkNode "sirius";
        vega = mkNode "vega";
        capella = mkNode "capella";
        homelab = mkNode "homelab";
      };
    };
    checks = builtins.mapAttrs (system: deployLib: deployLib.deployChecks self.deploy) deploy-rs.lib;
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/release-24.11";
    nixos-wsl = {
      url = "github:nix-community/nixos-wsl";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-vscode-extensions = {
      url = "github:nix-community/nix-vscode-extensions";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    wezterm-flake = {
      url = "github:wez/wezterm/main?dir=nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-secrets = {
      url = "git+ssh://git@github.com/tuxdotrs/nix-secrets.git?shallow=1";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    tfolio = {
      url = "git+ssh://git@github.com/tuxdotrs/tfolio.git";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    cyber-tux = {
      url = "git+ssh://git@github.com/tuxdotrs/cyber-tux.git";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    ghostty.url = "github:ghostty-org/ghostty";
    nixos-hardware.url = "github:nixos/nixos-hardware";
    nixpkgs-f2k.url = "github:moni-dz/nixpkgs-f2k";
    nur.url = "github:nix-community/nur";
    sops-nix.url = "github:Mic92/sops-nix";
    impermanence.url = "github:nix-community/impermanence";
    deploy-rs.url = "github:serokell/deploy-rs";
  };
}
