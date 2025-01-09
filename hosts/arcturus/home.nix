{username, ...}: {
  home.persistence."/persist/home/${username}" = {
    directories = [
      "Projects"
      "Stuff"
      ".ssh"
    ];
    files = [
      ".zsh_history"
    ];
    allowOther = true;
  };

  home.stateVersion = "24.11";
}
