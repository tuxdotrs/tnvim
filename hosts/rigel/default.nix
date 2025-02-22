{
  pkgs,
  username,
  outputs,
  inputs,
  email,
  ...
}: {
  imports = [
    ../../modules/droid/sshd.nix
  ];

  tux.services.openssh = {
    enable = true;
    ports = [8022];
    authorizedKeys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIL+OzPUe2ECPC929DqpkM39tl/vdNAXfsRnmrGfR+X3D ${email}"
    ];
  };

  user.shell = "${pkgs.zsh}/bin/zsh";

  environment.packages = with pkgs; [
    nano
    git
    neovim
    openssh
  ];

  home-manager = {
    config = ./home.nix;
    backupFileExtension = "backup";
    extraSpecialArgs = {inherit inputs outputs username email;};
    useGlobalPkgs = true;
  };

  # Set up nix for flakes
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  system.stateVersion = "24.05";
}
