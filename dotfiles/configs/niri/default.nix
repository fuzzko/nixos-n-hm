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
      "Mod+Alt+Right".action = with actions; focus-workspace-up;
      "Mod+Alt+Left".action = with actions; focus-workspace-down;
    };
}
