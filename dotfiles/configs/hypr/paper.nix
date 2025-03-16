{ root, ... }:
let
  wallpaper_dir = /${root}/../resources/wallpapers;
in {
  ipc = "on";
  preload = [
    /${wallpaper_dir}/wallpaper.png
  ];
  wallpaper = [
    ", ${wallpaper_dir}/wallpaper.png"
  ];
}
