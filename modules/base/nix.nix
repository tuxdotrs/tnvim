{
  pkgs,
  username,
  ...
}: {
  nix = {
    package = pkgs.lix;
    settings = {
      experimental-features = "nix-command flakes";
      auto-optimise-store = true;
      trusted-users = ["${username}"];
      warn-dirty = false;
    };
  };
}
