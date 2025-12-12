{...}:
{  services.greetd = {
    enable = true;
    settings.default_session = {
      command = "env GTK_USE_PORTAL=0 GDK_DEBUG=no-portals ${lib.getExe pkgs.cage} -s -mlast -- ${lib.getExe pkgs.regreet}";
    };
  };

  programs.regreet = {
    enable = true;
    theme = {
      name = "Graphite-Dark";
      package = pkgs.graphite-gtk-theme.override {
        themeVariants = [ "default" ];
        tweaks = [
          "rimless"
          "darker"
        ];
      };
    };
    cursorTheme = {
      name = "catppuccin-mocha-yellow-cursors";
      package = pkgs.catppuccin-cursors.mochaYellow;
    };
    iconTheme = {
    };
    settings = {
      background = {
        path = ./resources/wallpapers/regreet-wallpaper.png;
        fit = "Contain";
      };
    };
  };

}
