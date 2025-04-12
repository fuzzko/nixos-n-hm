{ ... }:
let
  mkCoord = x: y: "(${toString x}, ${toString y})";
in
{
  global = {
    follow = "mouse";
    enable_posix_regex = true;
    origin = "top-right";
    offset = mkCoord 10 10;
    dmenu = "wofi --dmenu -p dunst";
  };
}
