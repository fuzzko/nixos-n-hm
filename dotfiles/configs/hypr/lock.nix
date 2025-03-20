{ root, ... }:
let
  rgba =
    r: g: b: a:
    if a == null then
      "rgba(${toString r},${toString g},${toString b},1.0)"
    else
      "rgba(${toString r},${toString g},${toString b},${toString a})";
  rgb = r: g: b: rgba r g b null;
in
{
  general = {
    hide_cursor = true;
    ignore_empty_input = true;

  };

  background = {
    path = builtins.toString (/${root}/../resources/wallpapers/sorcerer-casting.jpg);
    blur_passes = 1;
  };

  input-field = {
    size = "200, 50";
    position = "0, -80";
    dots_center = true;
    fade_on_empty = false;
    font_color = rgb 202 211 245;
    inner_color = rgb 91 96 120;
    outer_color = rgb 24 25 38;
    outline_thickness = 5;
    placeholder_text = ''
      <span foreground="##cad3f5">Password...</span>
    '';
    shadow_passes = 2;
  };
}
