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

  nix = {
    package = pkgs.lixPackageSets.latest.lix;
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      trusted-users = [ "komo" ];
    };
  };

  boot = {
    loader = {
      grub.enable = lib.mkForce false;
      systemd-boot.enable = lib.mkForce true;
      efi.canTouchEfiVariables = true;
    };

    # comment this if something's fucked up
    kernelPackages = pkgs.linuxPackages_zen;

    kernelParams = [
      "vt.default_red=30,243,166,249,137,245,148,186,88,243,166,249,137,245,148,166"
      "vt.default_grn=30,139,227,226,180,194,226,194,91,139,227,226,180,194,226,173"
      "vt.default_blu=46,168,161,175,250,231,213,222,112,168,161,175,250,231,213,200"
    ];

    kernel.sysctl = {
      "vm.swappiness" = 100;
      "kernel.sysrq" = 1;
    };
  };

  time.timeZone = "Asia/Makassar";
  i18n.defaultLocale = "en_US.UTF-8";
}
