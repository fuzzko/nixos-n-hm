{ config, ... }:
let
  inherit (config.lib) komo;
  inherit (komo.hypr) percentXY;

  quadton = a: b: c: d: [
    a
    b
    c
    d
  ];
in
{
  programs.hyprlock.enable = true;

  programs.hyprlock.settings = {
    animation.bezier = komo.hypr.mkBeziers {
      easeOutExpo = quadton 0.16 1 0.3 1;
      easeOutCirc = quadton 0 0.55 0.45 1;
    };

    animation.animation = komo.hypr.mkAnimations {
      inputFieldFade = {
        speed = 5;
        curve = "easeOutExpo";
      };
      inputFieldColor = {
        speed = 8;
        curve = "easeOutCirc";
      };
    };

    background = {
      path = toString ./hyprlock-bg.png;

      blur_passes = 1;
      blur_size = 6;
    };

    input_field = {
      monitor = "";

      size = percentXY 10 5;
      outline_thickness = 5

      
    }
  };
}
