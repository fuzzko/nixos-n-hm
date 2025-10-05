{ ... }: {
  services.wluma.enable = true;
  services.wluma = {
    systemd.enable = true;
    systemd.target = "default.target";
  };

  services.wluma.settings = {
    als.time.thresholds = {
      "7" = "day";
      "18" = "night";
    };

    output.backlight = [
      {
        name = "eDP-1";
        path = "/sys/class/backlight/intel_backlight"
      }
    ];
  };
}
