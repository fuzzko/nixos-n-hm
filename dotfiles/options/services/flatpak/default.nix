{ ... }: {
    services.flatpak = {
    enable = true;
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
