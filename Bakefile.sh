init() {
  export NIX_CONFIG="$(< nix.conf)"
}

task.get-system-name() {
  nix eval --raw --impure --expr '
    let
      npins = import ./npins { };
      pkgs = import npins.nixpkgs { };
      komoLib = import ./lib pkgs.lib;
    in
    "System name: " + komoLib.systemProductName
  '
}

task.test() {
  local flags=(
    --ask
    --log-format multiline
    --show-trace
    --impure
    --keep-going
    --file ./nixos
  )

  [[ -v dry ]] &&
    flags+=(
      --dry
    )

  nh os test "${flags[@]}" ${args}
}

task.switch() {
  local flags=(
    --ask
    --log-format multiline
    --show-trace
    --impure
    --keep-going
    --file ./nixos
  )

  [[ -v dry ]] &&
    flags+=(
      --dry
    )

  nh os switch "${flags[@]}" ${args}
}

task.boot() {
  local flags=(
    --ask
    --log-format multiline
    --show-trace
    --impure
    --use-substitutes
    --keep-going
    --file ./nixos
  )

  [[ -v dry ]] &&
    flags+=(
      --dry
    )

  nh os build "${flags[@]}" ${args}
}
