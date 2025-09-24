{ config, ... }:
let
  inherit (config.lib.file)
    mkOutOfStoreSymlink
    ;
in
{
  programs.anyrun.enable = true;
  programs.anyrun.extraCss = ''
      @import url("${toString mkOutOfStoreSymlink ./anyrun.css}");
    '';
}
