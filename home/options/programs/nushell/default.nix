{
  npins,
  idc,
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

  nix-search-cli = idc {
    src = npins.nix-search-cli.outPath;
    settings.inputs.nixpkgs = npins.nixpkgs.outPath;
  };
in
{
  programs.nushell.enable = true;

  programs.nushell.configFile.text = ''
    let autoload = $nu.data-dir | path join "vendor/autoload"

    mkdir $autoload
    cp ${toString ./autoload}/* $autoload

    use ${npins.bash-env-nushell}/bash-env.nu
    if ("~/.nix-profile/etc/profile.d/hm-session-vars.sh" | path exists) {
      bash-env "~/.nix-profile/etc/profile.d/hm-session-vars.sh" | load-env
    }

    source ${toString ./config.nu}
  '';

  home.packages = with pkgs; [
    nix-search-cli.packages.${builtins.currentSystem}.nix-search
    bash-env-json
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
