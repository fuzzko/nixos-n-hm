{
  pkgs,
  ...
}:
let
  komoLib = import ../lib pkgs.lib;
in
{

  home.stateVersion = "24.05";
}
