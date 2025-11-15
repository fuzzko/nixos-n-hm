{ pkgs ? import <nixpkgs> {}}:

pkgs.mkShellNoCC {
  packages = with pkgs; [
    kdePackages.qtdeclarative
  ];
}
