{
  username,
  pkgs,
  ...
}: {
  virtualisation = {
    docker.enable = true;
  };

  environment.systemPackages = with pkgs; [lazydocker];

  users.users.${username}.extraGroups = ["docker"];
}
