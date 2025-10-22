{
  config,
  pkgs,
  lib,
  ...
}:
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
      gh-screensaver
      gh-f
      gh-notify
      gh-markdown-preview
      (lib.flatten extraExtensions)
    ];

  programs.gh.settings = {
    aliases = {
      rcl = "repo clone";
      rfk = "repo fork";
      rmv = "repo rename";
      rdl = "repo delete --yes";
    };
  };
}
