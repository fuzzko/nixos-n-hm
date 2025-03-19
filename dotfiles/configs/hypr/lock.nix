{ root, ... }:
let
  rgba =
    r: g: b: a:
    if a == null then
      "rgba(${toString r},${toString g},${toString b},1.0)"
    else
      "rgba(${toString r},${toString g},${toString b},${toString a})";
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
    size = "250, 55";
    position = "0, -80";
    dots_center = true;
    fade_on_empty = false;
    font_color = rgba 202 211 245 null;
    inner_color = rgba 91 96 120 null;
    outer_color = rgba 24 25 38 null;
    outline_thickness = 2;
    placeholder_text = ''
      <span foreground="##cad3f5">Password...</span>
    '';
    shadow_passes = 2;
  };
}
