{ ... }: {
  programs.nix-your-shell.enable = true;
  programs.nix-your-shell = {
    nix-output-monitor.enable = true;
  };
}
