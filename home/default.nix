{
  # pkgs,
  # config,
  ...
}@attrs:
# let
#   inherit (config.lib) komo;
# in
# assert builtins.trace (builtins.typeOf pkgs) false;
assert builtins.trace attrs true;
{
  # # A simple business logic to import all configs in ./options, you should check that dir too
  # imports = (komo.filterFilesInDir (x: (builtins.baseNameOf x) == "default.nix") ./options) ++ [
  #   ../modules/hm/moor
  # ];

  home.stateVersion = "24.05";
}
