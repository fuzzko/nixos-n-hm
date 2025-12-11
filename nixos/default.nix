let
  npins = import ../npins;
  pkgs = import npins.nixpkgs { };

  komoLib = import ../lib pkgs.lib;
in
komoLib.nixosSystem {
  modules = [
    ./configuration.nix
    ./hardwares/${komoLib.systemProductName}/configuration.nix
  ];
}
