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

  home.sessionVariables = {
    "PAGER" = lib.mkDefault cfg.package.meta.mainProgram;
  };
}
