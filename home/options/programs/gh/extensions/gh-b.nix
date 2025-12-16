pkgs:
let
  komoLib = import ../../../../../lib pkgs.lib;
  npins = import ../../../../../npins;
  
  inherit (pkgs)
    buildGoModule
    ;
in
buildGoModule (final: {
  pname = "gh-b";
  version = "0.2.3";

  src = npins.gh-b.outPath;
  
  vendorHash = "sha256-Qq7denlGwBdMjhdno9uLKsu64SaGEFXH8zCplNivsIM=";

  meta = {
    mainProgram = "gh-b";
  };
})
