{ ... }:
{
  services.flatpak.enable = true;
  services.flatpak = {
    packages = [
      "io.itch.itch"
      "org.vinegarhq.Sober"
      "com.usebottles.bottles"
    ];
    update.auto = {
      enable = true;
    };
    uninstallUnmanaged = true;
  };
}
