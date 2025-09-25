{ config, lib, ... }:
let
  pkg = config.programs.anyrun.package;
in
{
  programs.anyrun.enable = true;
  programs.anyrun.extraCss = ''
    @import url("${toString ./anyrun.css}");
  '';
  programs.anyrun.config = {
    plugins = [
      "${pkg}/lib/libapplications.so"
      "${pkg}/lib/libsymbols.so"
    ]
    ++ lib.optional (config.services.kidex.enable) "${pkg}/lib/libkidex.so";
  };
}
