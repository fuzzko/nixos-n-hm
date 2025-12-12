{ config, lib, ... }:
let
  cfg = config.programs.moor;
in
{
  programs.moor.enable = true;
  programs.moor.extraOptions = [
    "-reformat"
    "-render-unprintable highlight"
    "-shift 10"
    "-style autumn"
    "-wrap"
  ];

  programs.git.settings = {
    core.pager = config.home.sessionVariables.PAGER;
  };

  home.sessionVariables = {
    "PAGER" = lib.mkDefault cfg.package.meta.mainProgram;
  };
}
