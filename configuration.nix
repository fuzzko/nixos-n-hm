{
  pkgs,
  lib,
  ...
}:
let
  komoLib = import ./lib lib;

  npins = import ./npins;
in
{
  imports = (komoLib.filterFilesInDir (x: (builtins.baseNameOf x) == "default.nix") ./options) ++ [
    "${npins.home-manager}/nixos"
    "${npins.nix-flatpak}/modules/nixos.nix"
  ];

  system.stateVersion = "24.05";
  networking.hostName = "gudboye";

  environment.systemPackages = with pkgs; [
    gptfdisk
    efibootmgr

    (pkgs.callPackage "${npins.waterfox-flake}/package.nix" { }) # waterfox

    openutau
    dissent
  ];

  time.timeZone = "Asia/Makassar";
  i18n.defaultLocale = "en_US.UTF-8";
}
