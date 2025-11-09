{ config, ... }:
let
  inherit (config.lib) komo;
  inherit (komo.hypr) percentXY rgb textCmd;

  quadton = a: b: c: d: [
    a
    b
    c
    d
  ];

  timeGetScript = toString ./time.nu;
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
      outline_thickness = 5;

      outer_color = rgb 12 20 23;
      inner_color = rgb 207 225 235;

      check_color = rgb 0 133 172;
      fail_color = rgb 185 52 67;

      capslock_color = rgb 75 55 16;

      hide_input = true;
      hide_input_base_color = rgb 0 133 172;

      placeholder_text = "";
      fail_text = "<b>$FAIL</b>";

      fade_timeout = 1500;

      shadow_passes = 1;
      shadow_size = 1;
      shadow_boost = 1;

      position = percentXY 0 -23;
    };

    label = [
      # Hour Minute
      {
        monitor = "";

        text = textCmd 500 "nu ${timeGetScript} hourminute";
        text_align = "center";
        font_size = 70;
        font_family = "Noto Sans";

        color = rgb 117 172 199;

        shadow_passes = 1;
        shadow_boost = .8;

        position = percentXY 0 18;
      }
      # Date
      {
        monitor = "";

        text = textCmd 500 "nu ${timeGetScript} date";
        text_align = "center";
        font_size = 10;

        color = rgb 210 227 236;

        shadow_passes = 1;
        shadow_boost = .7;

        position = percentXY 0 4;
      }
    ];
  };
}
