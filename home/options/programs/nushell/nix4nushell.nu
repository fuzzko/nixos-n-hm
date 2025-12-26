export def nix --wrapped [...args] {
  match $args {
    [$subcmd, ..$rest] if $subcmd == "develop"
                       or $subcmd == "shell"
                       and not "--command" in $rest => (
      run-external nix $subcmd "--command" $nu.current-exe ...$rest
    )
    _ => (run-external nix ...$args)
  }
}
