{pkgs, ...}: {
  imports = [
    ../../modules/home/git
    ../../modules/home/starship
  ];

  programs = {
    bat.enable = true;
    zoxide = {
      enable = true;
      options = ["--cmd cd"];
    };
    zsh = {
      enable = true;
      shellAliases = {
        ls = "lsd";
      };
      syntaxHighlighting.enable = true;
      autosuggestion.enable = true;
    };
  };

  home.packages = with pkgs; [
    neovim
    busybox
    lsd
  ];

  home.stateVersion = "24.05";
}
