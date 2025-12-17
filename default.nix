let
  npins = import ./npins;
  pkgs = import npins.nixpkgs {
    config = {
      allowUnfree = true;
    };
  };

  komoLib = import ./lib pkgs.lib;
in
import "${npins.nixpkgs}/nixos/lib/eval-config.nix" {
  inherit pkgs;
  specialArgs.npins = npins;
  specialArgs.idc = import npins.idc;
  modules = [
    ./configuration.nix
    ./hardwares/${komoLib.systemProductName}/configuration.nix
  ];
}
