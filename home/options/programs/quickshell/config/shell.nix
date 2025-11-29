{ pkgs ? import <nixpkgs> {}}:
let
  inherit (pkgs) lib;
in
pkgs.mkShellNoCC {
  packages = with pkgs; [
    kdePackages.qtdeclarative
    quickshell
  ];

  env =
    let
      makeQmlImportPath = lib.makeSearchPath "lib/qt-6/qml";
      makeQmlPluginPath = lib.makeSearchPath "lib/qt-6/plugins";
    in
    {
      QML2_IMPORT_PATH = makeQmlImportPath (with pkgs; [
        "${kdePackages.qtdeclarative}"
        "${quickshell}"
      ]);
      QML_PLUGIN_PATH = makeQmlPluginPath (with pkgs; [
        "${kdePackages.qtdeclarative}"
      ]);
    };
}
