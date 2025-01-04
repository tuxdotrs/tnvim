{pkgs, ...}: {
  home.file = {
    ".config/ghostty/config" = {
      text = ''
        theme = rose-pine

        gtk-titlebar = false
        window-padding-x = 10
        window-padding-y = 10

        font-size = 16
      '';
    };
  };

  home.packages = with pkgs; [
    ghostty
  ];
}
