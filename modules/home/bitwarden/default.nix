{
  pkgs,
  email,
  ...
}: {
  programs.rbw = {
    enable = true;
    settings = {
      base_url = "https://bw.tux.rs";
      email = "${email}";
    };
  };

  home.packages = with pkgs; [
    bitwarden
  ];
}
