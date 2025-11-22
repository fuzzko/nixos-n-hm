{ pkgs ? import <nixpkgs> { } }:
pkgs.mkShellNoCC {
  packages = with pkgs; [
    (writeShellScriptBin "eww" ''
      ${lib.getExe eww} -c $PWD $@
    '')
  ];
}
