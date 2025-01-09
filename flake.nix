{
  description = "tux's NixOS Flake";

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
    ghostty.url = "github:ghostty-org/ghostty";
    nixos-hardware.url = "github:nixos/nixos-hardware";
    nixpkgs-f2k.url = "github:moni-dz/nixpkgs-f2k";
    nur.url = "github:nix-community/nur";
    sops-nix.url = "github:Mic92/sops-nix";
    impermanence.url = "github:nix-community/impermanence";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    ...
  } @ inputs: let
    inherit (self) outputs;
    inherit (inputs.nixpkgs.lib) nixosSystem;
    inherit (home-manager.lib) homeManagerConfiguration;
    forAllSystems = nixpkgs.lib.genAttrs [
      "x86_64-linux"
      "aarch64-linux"
    ];
    username = "tux";
    email = "t@tux.rs";
  in {
    packages = forAllSystems (system: import ./pkgs nixpkgs.legacyPackages.${system});
    formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);

    # Custom packages and modifications, exported as overlays
    overlays = import ./overlays {inherit inputs;};

    # NixOS configuration entrypoint
    # 'nixos-rebuild switch --flake .#your-hostname'
    nixosConfigurations = {
      arcturus = nixosSystem {
        specialArgs = {inherit inputs outputs username email;};
        modules = [./hosts/arcturus];
      };

      canopus = nixosSystem {
        specialArgs = {inherit inputs outputs username email;};
        modules = [./hosts/canopus];
      };

      alpha = nixosSystem {
        specialArgs = {inherit inputs outputs username email;};
        modules = [./hosts/alpha];
      };

      sirius = nixosSystem {
        specialArgs = {inherit inputs outputs username email;};
        modules = [./hosts/sirius];
      };

      vega = nixosSystem {
        specialArgs = {inherit inputs outputs username email;};
        modules = [./hosts/vega];
      };

      capella = nixosSystem {
        specialArgs = {inherit inputs outputs username email;};
        modules = [./hosts/capella];
      };

      vps = nixosSystem {
        specialArgs = {inherit inputs outputs username email;};
        modules = [./hosts/vps];
      };

      isoImage = nixosSystem {
        specialArgs = {inherit inputs outputs username email;};
        modules = [./hosts/isoImage];
      };

      homelab = nixosSystem {
        specialArgs = {inherit inputs outputs username email;};
        modules = [./hosts/homelab];
      };
    };

    # Standalone home-manager configuration entrypoint
    # home-manager switch --flake .#your-username@your-hostname'
    homeConfigurations = {
      "${username}@canopus" = homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        extraSpecialArgs = {inherit inputs outputs username email;};
        modules = [
          ./modules/home-manager
        ];
      };
    };
  };
}
