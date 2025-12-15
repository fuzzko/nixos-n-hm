{ pkgs, ... }:
{
  nix = {
    package = pkgs.lixPackageSets.latest.lix;
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      auto-optimise-store = true;
    };
    registry.nixpkgs = {
      from = {
        id = "nixpkgs";
        type = "indirect";
      };
      to = {
        owner = "NixOS";
        repo = "nixpkgs";
        ref = (import ../../../npins).nixpkgs.url;
        type = "github";
      };
    };
  };
}
