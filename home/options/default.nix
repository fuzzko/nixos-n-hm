# any options that does not need to have it's own dir
{ pkgs, ... }:
{
  xdg.configFile = {
    "zls.json".source = ../extras/zls.json;
  };
}
