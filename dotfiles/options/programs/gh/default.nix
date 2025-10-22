{ config, pkgs, lib, ... }:
let
  inherit (config.lib) komo;
in
{
  programs.gh.enable = true;
  programs.gh.extensions =
    let
      extraExtensions = map (x: import x pkgs) (komo.filesInDir ./extensions);
    in
    with pkgs;
    [
      gh-poi
      gh-eco
      gh-screensaver
      gh-s
      gh-f
      gh-notify
      gh-markdown-preview
      (lib.flatten extraExtensions)
    ];
}
