{ config, lib, ... }: {
  systemd.user.enable = true;
  systemd.user.targets = lib.optionalAttrs config.programs.niri.enable {
    niri-session.Unit = {
      Description = "Niri session target";
      BindsTo = "graphical-session.target";
      Wants = "xdg-desktop-autostart.target";
    };
  };
}
