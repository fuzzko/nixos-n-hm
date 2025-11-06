{
  config,
  lib,
  ...
}:
let
  inherit (config.lib) komo;
in
{
  # A simple business logic to import all configs in ./options, you should check that dir too
  imports = (komo.filterFilesInDir (x: if (builtins.baseNameOf x) == "default.nix" then builtins.trace "${toString x}\n" true else false) ./options) ++ [
    ../modules/hm/moor
  ];

  home.stateVersion = "24.05";
}
