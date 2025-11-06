{
  lib,
  pkgs,
  config,
  ...
}@attrs:
{
  programs.niri.enable = true;
  programs.niri = {
    settings = import ./settings.nix attrs;
  };

  home.packages = with pkgs; [
    xwayland-satellite-unstable
    cliphist
    libnotify
    wl-clipboard

    /*
      foot
      eww
      hypridle
      hyprlock
    */
  ];

  # for polkit agent
  systemd.user.services.soteria = rec {
    Service = {
      ExecStart = "${pkgs.soteria}/bin/soteria";
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };

    Install.WantedBy = [ "graphical-session.target" ];
    Unit.Wants = Install.WantedBy;
    Unit.After = Install.WantedBy;
  };

  xdg.portal.configPackages = lib.optionals (config.programs.niri.enable) [
    config.programs.niri.package
  ];
}
