let
   npins = import ../npins;
   nixpkgs = import npins.nixpkgs { };

   inherit (nixpkgs) lib;
in
lib.nixosSystem {
  modules = [];
}
