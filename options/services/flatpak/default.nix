{ ... }:
{
  services.flatpak.enable = true;
  services.flatpak.uninstallUnmanaged = true;

  services.flatpak.update = {
    onActivation = true;
    auto.enable = true;
    auto.onCalendar = "weekly";
  };

  services.flatpak.packages = [
    "com.collaboraoffice.Office"
    "org.vinegarhq.Sober"
    "com.usebottles.bottles"
  ];

  services.flatpak.overrides = {
    global = {
      Context.sockets = [
        "wayland"
        "!x11"
      ];

      Environment = {
        # Fix un-themed cursor in some Wayland apps
        XCURSOR_PATH = "/run/host/user-share/icons:/run/host/share/icons";

        # Force correct theme for some GTK apps
        GTK_THEME = "Adwaita:dark";
      };
    };
  };
}
