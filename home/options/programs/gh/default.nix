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
    lib.flatten [
      gh-poi
      gh-screensaver
      gh-f
      gh-notify
      gh-markdown-preview
      extraExtensions
    ];

  programs.gh.gitCredentialHelper.enable = true;
  
  programs.gh.settings = {
    prefer_editor_prompt = "enabled";
    aliases = {
      rcl = "repo clone";
      rfk = "repo fork";
      rmv = "repo rename";
      rdl = "repo delete --yes";
    };
  };
}
