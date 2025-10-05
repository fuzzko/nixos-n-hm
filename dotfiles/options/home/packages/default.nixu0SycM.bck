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
  home.packages = lib.flatten (map (x: builtins.attrValues x) (builtins.attrValues apps));
}
