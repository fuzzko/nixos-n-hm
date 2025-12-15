let
  npins = import ../npins;
  pkgs = import npins.nixpkgs { };
  hmLib = import "${npins.home-manager}/lib" { inherit (pkgs) lib; };
in
hmLib.homeManagerConfiguration {
  inherit pkgs;
  modules = [
    ({ ...}: {
      home.stateVersion = "26.05";
      home.username = builtins.getEnv "USER";
      home.homeDirectory = builtins.getEnv "HOME";
    })
    ./home.nix
  ];
}
