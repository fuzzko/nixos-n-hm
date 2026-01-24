let
  npins = import ./npins;
  idc = import npins.idc;
  pkgs = import npins.nixpkgs {
    config = {
      allowUnfree = true;
    };

    overlays = [
      (self: super: {
        inherit (import npins.zen-browser-flake { pkgs = super; }) zen-browser;
        nur = import npins.nur {
          pkgs = super;
          nurpkgs = super;
        };
      })
      (idc {
        src = npins.ElyPrismLauncher.outPath;
        settings.inputs.nixpkgs = npins.nixpkgs.outPath;
      }).overlays.default
    ];
  };

  komoLib = import ./lib pkgs.lib;
in
import "${npins.nixpkgs}/nixos/lib/eval-config.nix" {
  inherit pkgs;
  specialArgs = {
    inherit npins idc;
  };
  modules = [
    ./configuration.nix
    ./hardwares/${komoLib.systemProductName}/configuration.nix
  ];
}
