init() {
  export NIX_CONFIG="$(< ./nix.conf)"
}

task.get-system-name() {
  nix eval --raw --impure --expr '
    let
      npins = import ./npins;
      pkgs = import npins.nixpkgs { };
      komoLib = import ./lib pkgs.lib;
    in
    "System name: " + komoLib.systemProductName
  '
  echo
}

task.edit-option() {
  local for="$1" path="$2"

  case "${for}" in
    nixos)
      path="options/${path}";;
    home)
      path="home/options/${path}";;
    *)
      bake.die "unknown '${for}', choose between 'home' or 'nixos'"
  esac

  local default_nix="${path}/default.nix"

  if [[ -f "${default_nix}" ]]; then
    "${EDITOR}" "${default_nix}"
    exit "$?"
  fi

  mkdir -p "${path}"
  "${EDITOR}" "${default_nix}"
}

task.delete-option() {
  local for="$1" path="$2"
  
  case "${for}" in
    nixos)
      path="options/${path}";;
    home)
      path="home/options/${path}";;
    *)
      bake.die "unknown '${for}', choose between 'home' or 'nixos'"
  esac

  rm -frI "${path}"
}

task.build() {
  local flags=(
    --ask
    --log-format multiline
    --show-trace
    --impure
    --keep-going
    --file .
  )

  nh os build "${flags[@]}" "$@"
}

task.switch() {
  local flags=(
    --ask
    --log-format multiline
    --show-trace
    --impure
    --keep-going
    --file .
  )

  nh os switch "${flags[@]}" "$@"
}

task.boot() {
  local flags=(
    --ask
    --log-format multiline
    --show-trace
    --impure
    --keep-going
    --file .
  )

  nh os boot "${flags[@]}" "$@"
}
