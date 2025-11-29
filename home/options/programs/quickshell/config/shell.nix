{ ... }:
let
  komo' = import ../../../../../lib {};
  pkgs = (builtins.getFlake "github:NixOS/nixpkgs/${(komo'.getFlakeInputGithub "nixpkgs").locked.rev}").legacyPackages.${builtins.currentSystem};

  inherit (pkgs) lib;
  
  makeQmlImportPath = lib.makeSearchPathOutput "out" "lib/qt-6/qml";
  makeQmlPluginPath = lib.makeSearchPathOutput "out" "lib/qt-6/plugins";
in
pkgs.mkShellNoCC {
  packages = with pkgs; [
    kdePackages.qtdeclarative
    quickshell
  ];

  QML_IMPORT_PATH = makeQmlImportPath (with pkgs; [
    kdePackages.qtdeclarative
    quickshell
  ]);
  QML_PLUGIN_PATH = makeQmlPluginPath (with pkgs; [
    kdePackages.qtdeclarative
  ]);
}
