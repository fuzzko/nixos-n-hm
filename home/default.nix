let
  npins = import ../npins;
  pkgs = import npins.nixpkgs { };
  hmLib = import "${npins.home-manager}/lib" { inherit (pkgs) lib; };
in
hmLib.homeManagerConfiguration {
  inherit pkgs;
  specialArgs.npins = npins;
  specialArgs.idc = import npins.idc;
  modules = [
    (
      { ... }:
      {
        home.username = builtins.getEnv "USER";
        home.homeDirectory = builtins.getEnv "HOME";
      }
    )
    ./home.nix
  ];
}
