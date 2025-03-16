{ root, ... }:
let
  wallpaper_dir = /${root}/../resources/wallpapers;
in {
  ipc = "on";
  preload = [
    "${toString wallpaper_dir}/wallpaper.png"
  ];
  wallpaper = [
    ", ${toString wallpaper_dir}/wallpaper.png"
  ];
}
