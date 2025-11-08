pkgs:
let
  komo = import ../../../../../lib pkgs.lib;
  
  inherit (pkgs)
    buildGoModule
    fetchFromGitHub
    ;

  input = komo.getFlakeInputGithub "gh-b";
in
buildGoModule (final: {
  pname = "gh-b";
  version = "0.2.3";

  src = fetchFromGitHub {
    inherit (input.locked) owner repo rev;
    hash = input.locked.narHash;
  };

  vendorHash = pkgs.lib.fakeHash;

  meta = {
    mainProgram = "gh-b";
  };
})
