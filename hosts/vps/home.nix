{username, ...}: {
  home.persistence."/persist/home/${username}" = {
    directories = [
      "Projects"
      ".ssh"
    ];
    files = [
      ".zsh_history"
    ];
    allowOther = true;
  };

  home.stateVersion = "24.11";
}
