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
      # (sh ''
      #   if ! test -f /tmp/wired.sock; then
      #     exec wired
      #   fi
      # '')
      # (sh ''
      #   if ! test -f /tmp/wpaperd.sock || ! test -f /run/user/1000/wpaperd.sock; then
      #     exec wpaperd -d
      #   fi
      # '')
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
      sh = with actions; spawn "sh" "-c";
    in
    workspaceBinds
    // {
      "Mod+0".action = with actions; focus-workspace "special";
      "Mod+Alt+Right".action = with actions; focus-workspace-up;
      "Mod+Alt+Left".action = with actions; focus-workspace-down;

      "Mod+Q".action = with actions; spawn "anyrun";
      "Mod+Shift+Q".action = with actions; spawn "foot";
    };

  xwayland-satellite.enable = true;
}
