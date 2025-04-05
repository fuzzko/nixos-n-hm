#!/usr/bin/env bash

nix() {
  command nix --extra-experimental-features "nix-command flakes" "$@"
}
export -f nix

task.switch-hm() {
  nix run nixpkgs#nh -- home switch -a -c komo -b backup .
}

task.switch-nixos() {
  local config
  config="$(
    sed 's| |-|g' /sys/devices/virtual/dmi/id/product_name
  )"
  [[ "$1" != "-" ]] && config="$1"
  shift

  nix run nixpkgs#nh -- os switch -a -H komo -s "$config" .
}

task.boot-nixos() {
  local config
  config="$(
    sed 's| |-|g' /sys/devices/virtual/dmi/id/product_name
  )"
  [[ "$1" != "-" ]] && config="$1"
  shift

  nix run nixpkgs#nh -- os boot -a -H komo -s "$config" .
}

task.switch-nix-on-droid() {
  local config="${1:-$(getprop ro.product.vendor.model)}"
  nix-on-droid switch --flake .#"$config"
}

task.list-nixos() {
  echo
  echo "NixOS configurations:"
  grep nixosConfigurations flake.nix |
    awk -F' ' '/.+/ { print $1; }' |
    awk -F. '/.+/ { print $2; }' |
    sed 's/^/ - /'
  echo
}

task.list-nix-on-droid() {
  echo
  echo "nix-on-droid configurations:"
  grep nixOnDroidConfigurations flake.nix |
    awk -F' ' '/.+/ { print $1; }' |
    awk -F. '/.+/ { print $2; }' |
    sed 's/^/ - /'
  echo
}
