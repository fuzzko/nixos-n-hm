{ config, ... }:
let
  inherit (config.lib) komo;
in
{
  programs.hyprlock.enable = true;

  programs.hyprlock.settings = {
    animation.bezier = komo.hypr.mkBeziers {
      easeOutExpo = [
        0.16
        1
        0.3
        1
      ];
      easeOutCirc = [
        0
        0.55
        0.45
        1
      ];
    };

  };
}
