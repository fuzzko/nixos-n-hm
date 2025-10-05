{ pkgs, lib, ... }:
let
  apps = {
    "cool apps" = with pkgs; [
      ascii-draw # for idk smth
    ];
    "apps i would prob use" = with pkgs; [
      fractal # matrix chat
      packet # file transfer
    ];
  };
in
{
  home.packages = builtins.attrValues apps;
}
