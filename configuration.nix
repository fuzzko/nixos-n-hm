{
  pkgs,
  lib,
  npins,
  ...
}:
let
  komoLib = import ./lib lib;
in
{
  imports = (komoLib.filterFilesInDir (x: baseNameOf x == "default.nix") ./options) ++ [
    "${npins.home-manager}/nixos"
    "${npins.nix-flatpak}/modules/nixos.nix"
  ];

  system.stateVersion = "24.05";
  networking.hostName = "gudboye";

  environment.systemPackages = with pkgs; [
    gptfdisk
    efibootmgr

    openutau
    legcord
    kooha
    scrcpy
    wl-clipboard
    obsidian
    qview
    davinci-resolve
    android-tools
    (import npins.zen-browser-flake { inherit pkgs; }).zen-browser
  ];

  time.timeZone = "Asia/Makassar";
  i18n.defaultLocale = "en_US.UTF-8";
}
