{ ... }:
let
  npins = import ../../../../npins;
in
{
  programs.nushell.enable = true;

  programs.nushell.configFile.text = ''
    let npins = r#"${builtins.toJSON npins}"# | from json
    let autoload = $nu.data-dir | path join "vendor/autoload"

    mkdir $autoload
    cp ${toString ./autoload}/* $autoload

    source ${toString ./config.nu}
  '';
}
