{
  config,
  ...
}:
let
  inherit (config.lib) komo;
in
{
  # A simple business logic to import all configs in ./options, you should check that dir too
  import =
    let
      x = (komo.filterFilesInDir (x: (builtins.baseNameOf x) == "default.nix") ./options) ++ [
        ../modules/hm/moor
      ];
    in
    assert builtins.trace x true;
    x;

  home.stateVersion = "24.05";
}
