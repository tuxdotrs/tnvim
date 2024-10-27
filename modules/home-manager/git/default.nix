{...}: {
  programs.git = {
    enable = true;
    userName = "tuxdotrs";
    userEmail = "t@tux.rs";
    signing = {
      key = "~/.ssh/id_ed25519.pub";
      signByDefault = true;
    };
    extraConfig = {
      init.defaultBranch = "main";
      commit.gpgSign = true;
      gpg.format = "ssh";
    };
  };
}
