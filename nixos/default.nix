let
  npins = import ../npins;
  nixpkgs = import npins.nixpkgs { };
  
  nixosSystem =
    args:
    import ./nixos/lib/eval-config.nix (
      {
        lib = nixpkgs.lib;
        # Allow system to be set modularly in nixpkgs.system.
        # We set it to null, to remove the "legacy" entrypoint's
        # non-hermetic default.
        system = null;

        modules = args.modules ++ [
          # This module is injected here since it exposes the nixpkgs self-path in as
          # constrained of contexts as possible to avoid more things depending on it and
          # introducing unnecessary potential fragility to changes in flakes itself.
          #
          # See: failed attempt to make pkgs.path not copy when using flakes:
          # https://github.com/NixOS/nixpkgs/pull/153594#issuecomment-1023287913
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
