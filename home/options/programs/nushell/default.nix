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
    dragon-drop
    sigi
    sd
    ouch
    gum
    glow
    gut
    igrep
  ];

  home.sessionVariables.LS_COLORS =
    let
      escapedVal =
        readFile "${npins.LS_COLORS}/lscolors.csh"
        |> split " "
        |> last
        |> trim
        ;
      actualVal = match "'(.+)'" escapedVal |> last;
    in
    actualVal;
}
