#!/usr/bin/env bash

nix() {
  command nix --extra-experimental-features "nix-command flakes" "$@"
}
export -f nix

task.init-hm-gcroots() {
  local srcdir
  local gcroots="/nix/var/nix/gcroots/per-user/${USER}"
  srcdir=$(nix eval --expr '{ json }: (builtins.fromJSON json)' --argstr json "$(nix flake archive --json --dry-run)" path --raw)
  if [[ ! -d ~/.local/state/home-manager/gcroots/current-home && ! -d "${srcdir}" ]]; then
    bake.warn "Cannot initialize a gcroot for home-manager"
  else
    sudo mkdir -p "/nix/var/nix/gcroots/per-user/${USER}"
    [[ -d "${gcroots}/current-home" ]] &&
      sudo rm -f "${gcroots}/current-home"
    [[ -d "${gcroots}/nixcfg-srcdir" ]] &&
      sudo rm -f "${gcroots}/nixcfg-srcdir"
    sudo ln -s ~/.local/state/home-manager/gcroots/current-home "${gcroots}/current-home"
    sudo ln -s "${srcdir}" "${gcroots}/nixcfg-srcdir"
  fi
}

task.switch-hm() {
  nix run nixpkgs#nh -- home switch -a -c komo -b backup . -- --impure "$@"
  ./bake init-hm-gcroots
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
