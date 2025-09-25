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
      "${pkg}/lib/libshell.so"
      "${pkg}/lib/librink.so"
      "${pkg}/lib/libwebsearch.so"
      "${pkg}/lib/libnix_run.so"
    ]
    ++ lib.optional config.services.kidex.enable "${pkg}/lib/libkidex.so"
    ++ lib.optional config.programs.niri.enable "${pkg}/lib/libniri_focus.so";
  };
}
