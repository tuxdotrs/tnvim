{username, ...}: {
  home.persistence."/persist/home/${username}" = {
    directories = [
      "Projects"
      "Stuff"
      ".ssh"
    ];
    files = [
      ".zsh_history"
      ".zcompdump"
    ];
    allowOther = true;
  };

  home.stateVersion = "24.11";
}
