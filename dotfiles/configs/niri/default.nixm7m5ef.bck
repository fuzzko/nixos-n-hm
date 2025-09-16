{ config, lib, ... }:
let
  inherit (builtins)
    listToAttrs;
  inherit (config.lib.niri) actions;
in
{
  outputs."eDP-1" = {
    focus-at-startup = true;
  };

  binds =
  let
    workspaceBinds = listToAttrs (map (i: {
      name = "Mod+${i}";
      value = {
        action = with actions; focus-workspace 1;
      };
    }) (lib.range 1 9));
  in
  workspaceBinds //
  {
  };
}
