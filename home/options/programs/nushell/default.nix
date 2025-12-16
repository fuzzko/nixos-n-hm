{ npins, lib, ... }:
let
  inherit (builtins)
    readFile
    split
    match
    ;

  inherit (lib)
    last
    ;
in
{
  programs.nushell.enable = true;

  programs.nushell.configFile.text = ''
    let autoload = $nu.data-dir | path join "vendor/autoload"

    mkdir $autoload
    cp ${toString ./autoload}/* $autoload

    source ${toString ./config.nu}
  '';

  home.sessionVariables.LS_COLORS =
    let
      escapedVal = last (split " " (readFile "${npins.LS_COLORS}/lscolors.csh"));
      actualVal = last (match "'(.+)'" escapedVal);
    in
    actualVal;
}
