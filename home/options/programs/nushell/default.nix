{
  npins,
  pkgs,
  lib,
  config,
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

  idc = import npins.idc;

  nix-search-cli = idc {
    src = npins.nix-search-cli.outPath;
    settings.inputs.nixpkgs = npins.nixpkgs;
  };
in
{
  programs.nushell.enable = true;

  programs.nushell.configFile.text = ''
    let autoload = $nu.data-dir | path join "vendor/autoload"

    mkdir $autoload
    cp ${toString ./autoload}/* $autoload

    source ${toString ./config.nu}
  '';

  home.packages = with pkgs; [
    nix-search-cli.packages.${builtins.currentSystem}.nix-search
    libnotify
    cachix
    unzip
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
