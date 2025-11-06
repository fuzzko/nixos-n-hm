{ config, pkgs, ... }:
{
  nix = {
    package = pkgs.lixPackageSets.latest.lix;
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      allowed-users = [ config.home.username ];
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
        ref = (builtins.fromJSON (builtins.readFile ../../flake.lock)).nodes.nixpkgs.locked.rev;
        type = "github";
      };
    };
  };
}
