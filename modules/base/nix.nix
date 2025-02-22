{
  pkgs,
  username,
  ...
}: {
  nix = {
    package = pkgs.lix;

    gc = {
      automatic = true;
      options = "--delete-older-than 3d";
    };

    channel.enable = false;

    settings = {
      auto-optimise-store = true;
      allowed-users = ["${username}"];
      trusted-users = ["${username}"];
      experimental-features = "nix-command flakes";
      keep-going = true;
      warn-dirty = false;
      http-connections = 50;
    };
  };
}
