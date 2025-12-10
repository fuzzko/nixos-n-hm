init() {
  nixpkgs_pin=$(nix-instantiate --eval ./npins -A nixpkgs.outPath |tr -d \")
  export NIX_PATH="nixpkgs=${nixpkgs_pin}:nixos-config=${PWD}/nixos/configuration.nix"

  : "${config:=$(task.get-system-name)}"
  export config
}

task.get-system-name() {
  local product_name=/sys/devices/virtual/dmi/id/product_name 
  
  [[ ! -f "${product_name}" ]] &&
    { echo unknown; exit; }

  sed 's| |-|g' "${product_name}"
}

task.dry-build() {
  nixos-rebuild dry-build \
    --show-trace
}

task.switch() {
  nixos-rebuild switch \
    --log-format internal-json \
    --verbose \
    --keep-going \
    --show-trace \
    "$@" \
    |& nom
}
