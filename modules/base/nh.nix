{
  config,
  username,
  ...
}: {
  programs.nh = {
    enable = true;

    clean = {
      enable = !config.nix.gc.automatic;
      dates = "weekly";
    };

    flake = "/home/${username}/Projects/nixos-config";
  };
}
