{username, ...}: {
  home.persistence."/persist/home/${username}" = {
    directories = [
      "Projects"
      "Stuff"
      ".ssh"
      ".wakatime"
      ".config/sops"
      ".local/share/nvim"
      ".local/share/zoxide"
      ".local/state/lazygit"
    ];
    files = [
      ".zsh_history"
      ".wakatime.cfg"
    ];
    allowOther = true;
  };

  home.stateVersion = "24.11";
}
