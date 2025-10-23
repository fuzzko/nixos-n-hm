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

  programs.git.extraConfig = {
    core.pager = config.home.sessionVariables.PAGER;
  };

  home.sessionVariables = rec {
    "PAGER" = lib.mkDefault cfg.package.meta.mainProgram;
    "GIT_PAGER" = PAGER;
  };
}
