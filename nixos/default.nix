let
  npins = import ../npins;
  pkgs = import npins.nixpkgs { };
  
  nixosSystem =
    # ugly modification of lib.nixosSystem from the flake
    args:
    import "${npins.nixpkgs}/nixos/lib/eval-config.nix" (
      {
        inherit (pkgs) lib;
        inherit (pkgs.stdenv.hostPlatform) system;

        modules = args.modules ++ [
          (
            {
              config,
              pkgs,
              lib,
              ...
            }:
            {
              config.nixpkgs.flake.source = npins.nixpkgs.outPath;
            }
          )
        ];
      }
      // removeAttrs args [ "modules" ]
    );
in
nixosSystem {
  modules = [ ];
}
