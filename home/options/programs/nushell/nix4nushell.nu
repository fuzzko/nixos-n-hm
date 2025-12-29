export def nix --wrapped [...args] {
  match $args {
    [$subcmd, ..$rest] if $subcmd == "develop"
                       or $subcmd == "shell"
                       and "--command" not-in $rest => (
      run-external nix ...$args "--command" $nu.current-exe
    )
    _ => (run-external nix ...$args)
  }
}
