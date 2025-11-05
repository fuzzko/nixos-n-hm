{
  config,
  ...
}:
let
  inherit (config.lib) komo;
in
{
  # A simple business logic to import all configs in ./options, you should check that dir too
  import = (komo.filterFilesInDir (x: (builtins.baseNameOf x) == "default.nix") ./options) ++ [
    ../modules/hm/moor
  ];
}
