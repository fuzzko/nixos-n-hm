{
  lib,
  pkgs,
  config,
  npins,
  ...
}:
let
  komoLib = config.lib.komo;
  
  flakes = komoLib.npinsToFlakes npins;
in
{
  home.packages = lib.flatten (
    with pkgs;
    [
      # Fonts

      # Nix-purpose
      flakes.nix-search-cli.packages.${builtins.currentSystem}.nix-search
      cachix

      # Misc.
      micro
      moor
      glow
      libnotify
      unzip
      ouch

      # Something that would ease me off
      riff
      khal
      sd
      zoxide
      sigi
      gum
      dragon-drop
      obsidian

      # For hyprland
      wl-clipboard
      nushell

      kooha
      scrcpy

      youtube-music
      qview
      openutau
      nchat
      audacity
      igrep
    ]
  );

  home.sessionVariables = {
    "SYSTEMD_PAGERSECURE" = "true";
  };
}
