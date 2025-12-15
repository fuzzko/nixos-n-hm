{ config, ... }:
let
  homeLib = config.lib;
  komoLib = homeLib.komo;
in
{
  xdg.configFile."cosmic".source = homeLib.file.mkOutOfStoreSymlink (toString ./config);
}
