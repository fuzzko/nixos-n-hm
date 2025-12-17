{ lib, pkgs, config, npins, ... }:
let
  komoLib = config.lib.komo;

  flakes = komoLib.npinsToFlakes npins;
  cachyos-kernel = flakes.nix-cachyos-kernel.legacyPackages.${builtins.currentSystem};
in
{
  boot = {
    loader = {
      grub.enable = lib.mkForce false;
      systemd-boot.enable = lib.mkForce true;
      efi.canTouchEfiVariables = true;
    };

    # comment this if something's fucked up
    kernelPackages = cachyos-kernel;

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
}
