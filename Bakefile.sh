init() {
  nixpkgs_pin=$(nix-instantiate --eval ./npins -A nixpkgs.outPath |tr -d \")
  export NIX_PATH="nixpkgs=${nixpkgs_pin}:nixos-config=${PWD}/nixos/configuration.nix"

  export NIX_CONFIG="$(< nix.conf)"

  : "${config:=$(task.get-system-name)}"
  export config
}

task.get-system-name() {
  nix eval --raw --impure --expr "
    let
      npins = import ./npins { };
      pkgs = import npins.nixpkgs { };
      komoLib = import ./lib pkgs.lib;
    in
    komoLib.systemProductName
  "
}

task.dry-build() {
  nixos-rebuild dry-build \
    --show-trace
}

task.dry-activate() {
  nixos-rebuild dry-activate \
    --keep-going \
    --show-trace \
    "$@" \
    |& nom
}

task.switch() {
  nixos-rebuild switch \
    --keep-going \
    --show-trace \
    "$@" \
    |& nom
}

task.boot() {
  nixos-rebuild boot \
    --keep-going \
    --show-trace \
    "$@" \
    |& nom
}
