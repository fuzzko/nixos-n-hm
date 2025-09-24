{ ... }: {
  programs.niri.enable = true;
  programs.niri = {
    settings = import ./settings.nix;
  };
}
