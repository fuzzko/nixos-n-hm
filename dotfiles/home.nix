{
  config,
  pkgs,
  lib,
  ...
}@inputs:
let
  wrapGL = config.lib.nixGL.wrap;

  inherit (config.lib) komo;

  loadConfig = x: y: import ./configs/${x}.nix (inputs // { root = ./.; } // y);
  loadConfig' = x: y: import ./configs/${x} (inputs // { root = ./.; } // y);
in
{
  # A simple business logic to import all configs in ./options, you should check that dir too
  import = (komo.filterFilesInDir (x: (builtins.baseNameOf x) == "default.nix") ./options) ++ [
    ../modules/hm/moor
  ];

  home.pointerCursor.enable = true;
  home.pointerCursor.size = 15;
  home.pointerCursor = {
    hyprcursor.enable = true;
    x11.enable = true;
  };

  programs.nix-index.enable = true;

  programs.git = {
    enable = true;
    userName = "Komo";
    userEmail = "afiqquraisyzulkarnain@gmail.com";
  };

  services.hypridle = {
    enable = true;
    settings = loadConfig "hypr/idle" { };
  };

  services.hyprpaper = {
    enable = true;
    settings = loadConfig "hypr/paper" { };
  };

  programs.hyprlock = {
    enable = true;
    settings = loadConfig "hypr/lock" { };
  };

  wayland.windowManager.hyprland = {
    enable = true;
    package = null;
    settings = loadConfig "hypr/wm" { };
    xwayland.enable = true;
  };
}
