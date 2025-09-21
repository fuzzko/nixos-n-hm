{ config, lib, ... }:
let
  inherit (builtins)
    listToAttrs
    ;
  inherit (config.lib.niri) actions;
in
{
  outputs."eDP-1" = {
    focus-at-startup = true;
  };

  input = {
    workspace-auto-back-and-forth = true;
  };

  workspaces."special" = {};

  environment = {
    "ELECTRON_OZONE_PLATFORM_HINT" = "auto";
    "_JAVA_AWT_WM_NONREPARENTING" = "1";
  };

  spawn-at-startup =
    let
      spawn = {
        argv = [];
        __functor = self: arg: self // {
          argv = self.argv ++ [arg];
        };
      };
      sh = sh: { inherit sh; };
    in
    [
      (spawn "niri" "msg" "action" "focus-workspace" "1")
      
      ## uncomment this if you're not using home-manager
      # (spawn "wired")
      # (spawn "wpaperd" "-d")
      # (spawn "hypridle")
      # (spawn "eww" "daemon")
    ];

  binds =
    let
      workspaceBinds = listToAttrs (
        map (i: {
          name = "Mod+${i}";
          value = {
            action = with actions; focus-workspace i;
          };
        }) (lib.range 1 9)
      );
    in
    workspaceBinds
    // {
      "Ctrl+Alt+Delete" = with actions; quit;
      
      "Mod+0".action = with actions; focus-workspace "special";

      "Mod+Left".action = with actions; focus-column-left;
      "Mod+Right".action = with actions; focus-column-right;
      "Mod+Up".action = with actions; focus-window-up-or-to-workspace-up;
      "Mod+Down".action = with actions; focus-window-down-or-to-workspace-down;

      "Mod+Home".action = with actions; focus-column-first;
      "Mod+End".action = with actions; focus-column-left;

      "Mod+Shift+Left".action = with actions; move-column-left;
      "Mod+Shift+Right".action = with actions; move-column-right;
      "Mod+Shift+Up".action = with actions; move-window-to-workspace-up { focus = true; };
      "Mod+Shift+Down".action = with actions; move-window-to-workspace-down { focus = true; };

      "Mod+C" = {
        action = with actions; close-window;
        repeat = false;
      };
      "Mod+Alt+C" = {
        action = with actions; spawn "nu" (toString ./scripts/sigkill-focused-window.nu);
        repeat = false;
      };

      "Mod+F".action = with actions; toggle-window-floating;
      "Mod+V".action = with actions; fullscreen-window;

      "Mod+Q".action = with actions; spawn "anyrun";
      "Mod+Shift+Q".action = with actions; spawn "foot";
      
      "Print".action = with actions; screenshot;
      "Mod+Print".action = with actions; screenshot-window;
      # "Ctrl+Print".action = with actions; screenshot-screen;
    };

  xwayland-satellite.enable = true;
}
