#!/usr/bin/env bash

nix() {
  command nix --extra-experimental-features "nix-command flakes" "$@"
}
export -f nix

task.init-hm-gcroot() {
  if [[ ! -d ~/.local/state/home-manager/gcroots/current-home ]]; then
    bake.warn "Cannot initialize a gcroot for home-manager"
    return 1
  fi

  if [[ -d "/nix/var/nix/gcroots/per-user/${USER}/current-home" ]]; then
    bake.warn "Gcroot is already initialized"
    return 1
  fi

  sudo mkdir -p "/nix/var/nix/gcroots/per-user/${USER}"
  sudo ln -s ~/.local/state/home-manager/gcroots/current-home "/nix/var/nix/gcroots/per-user/${USER}/current-home"
}

task.switch-hm() {
  nix run nixpkgs#nh -- home switch -a -c komo -b backup . -- --impure "$@"
}

task.switch-nixos() {
  local config
  config="$(
    sed 's| |-|g' /sys/devices/virtual/dmi/id/product_name
  )"
  [[ "$1" != "-" ]] && config="$1"
  shift

  nix run nixpkgs#nh -- os switch -a -H "$config" . -- --impure "$@"
}

task.boot-nixos() {
  local config
  config="$(
    sed 's| |-|g' /sys/devices/virtual/dmi/id/product_name
  )"
  [[ "$1" != "-" ]] && config="$1"
  shift
 
  nix run nixpkgs#nh -- os boot -a -H gudboye -s "$config" . -- --impure "$@"
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
