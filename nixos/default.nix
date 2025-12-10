let
  npins = import ../npins;
  nixpkgs = import npins.nixpkgs { };
  
  nixosSystem =
    # ugly modified of lib.nixosSystem from the flake
    args:
    import /${npins.nixpkgs}/nixos/lib/eval-config.nix (
      {
        lib = nixpkgs.lib;
        system = null;

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
