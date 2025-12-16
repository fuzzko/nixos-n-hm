let
  npins = import ./npins;
  pkgs = import npins.nixpkgs {
    config = {
      allowUnfree = true;
    };
  };

  komoLib = import ./lib pkgs.lib;
in
komoLib.nixosSystem {
  inherit pkgs;
  specialArgs.npins = npins;
  modules = [
    ./configuration.nix
    ./hardwares/${komoLib.systemProductName}/configuration.nix
  ];
}
