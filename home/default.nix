let
  npins = import ../npins;
  pkgs = import npins.nixpkgs {
    overlays = [
      (self: super: {
        inherit (import npins.zen-browser-flake { pkgs = super; }) zen-browser;
      })
    ];
  };
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
