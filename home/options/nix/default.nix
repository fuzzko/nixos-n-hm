{ pkgs, lib, ... }:
{
  nix = {
    package = lib.mkForce pkgs.lixPackageSets.latest.lix;
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      auto-optimise-store = true;
    };
    registry.nixpkgs = {
      from = {
        type = "indirect";
        id = "nixpkgs";
      };
      to = {
        type = "tarball";
        inherit ((import ../../../npins).nixpkgs) url;
      };
    };
  };
}
