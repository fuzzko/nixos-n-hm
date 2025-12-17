{
  npins,
  pkgs,
  lib,
  ...
}:
let
  inherit (builtins)
    readFile
    split
    match
    ;

  inherit (lib)
    last
    trim
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

  # extra clis
  home.packages = with pkgs; [
    gum
    glow
    gut
  ];

  home.sessionVariables.LS_COLORS =
    let
      escapedVal = lib.pipe (readFile "${npins.LS_COLORS}/lscolors.csh") [
        (split " ")
        last
        trim
      ];
      actualVal = last (match "'(.+)'" escapedVal);
    in
    actualVal;
}
