pkgs:
let
  inherit (pkgs)
    buildGoModule
    fetchFromGitHub
    ;
in
buildGoModule (final: {
  pname = "gh-b";
  version = "0.2.3";

  src = fetchFromGitHub {
    owner = "joaom00";
    repo = "gh-b";
    tag = "v${final.version}";
    hash = "sha256-GzgGY+b++Y1pCpI1a99TEpv1I950TiByH5Bd/K2Egw0=";
  };

  vendorHash = pkgs.lib.fakeHash;

  meta = {
    mainProgram = "gh-b";
  };
})
