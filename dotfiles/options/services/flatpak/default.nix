{ ... }:
{
  services.flatpak.enable = true;
  services.flatpak = {
    update.auto = {
      enable = true;
      onCalendar = "weekly";
    };
    uninstallUnmanaged = true;
  };

  services.flatpak.overrides = {
    global = {
      # force some apps to use wayland
      Context.sockets = [
        "fallback-x11"
        "!x11"
        "wayland"
      ];

      Environment = {
        # Fix un-themed cursor in some Wayland apps
        XCURSOR_PATH = "/run/host/user-share/icons:/run/host/share/icons";

        # Force correct theme for some GTK apps
        GTK_THEME = "Adwaita:dark";
      };
    };
  };

  services.flatpak.packages = [
    "io.itch.itch"
    "org.vinegarhq.Sober"
    "com.usebottles.bottles"
  ];
}
