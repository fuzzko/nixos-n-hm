{ pkgs, ... }@attrs: {
  programs.niri.enable = true;
  programs.niri = {
    settings = import ./settings.nix attrs;
  };

  home.packages = with pkgs; [
    xwayland-satellite-unstable
    cliphist
    wl-clipboard

    # foot
    # eww
  ];
}
