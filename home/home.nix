{...}:
let
  komoLib = import ../lib {};
in
{
  # A simple business logic to import all configs in ./options, you should check that dir too
  imports = (komoLib.filterFilesInDir (x: (builtins.baseNameOf x) == "default.nix") ./options) ++ [
    ../modules/hm/moor
  ];

  home.stateVersion = "24.05";
}
