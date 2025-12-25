def nix_your_shell [command: string, args: list<any>] {
  let args = [$command ...$args]
  if (which nix-your-shell | is-not-empty) {
    let args = $args | insert 0 "--nom" | flatten
    run-external nix-your-shell nu ...$args
  } else {
    run-external ...$args
  }
}

export def --wrapped nix-shell [...args] {
  nix_your_shell nix-shell $args
}

export def --wrapped nix [...args] {
  nix_your_shell nix $args
}
