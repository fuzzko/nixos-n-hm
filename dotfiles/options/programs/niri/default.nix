{ lib, pkgs, config, ... }@attrs:
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

  xdg.portal.configPackages = lib.optionals (config.programs.niri.enable) [
    config.programs.niri.package
  ];
}
