{ lib, npins, idc, ... }:
let
  nix-cachyos-kernel = idc {
    src = npins.nix-cachyos-kernel.outPath;
    settings.inputs.nixpkgs = npins.nixpkgs.outPath;
  };
  cachyosKernels = nix-cachyos-kernel.legacyPackages.${builtins.currentSystem};
in
{
  boot = {
    loader = {
      grub.enable = lib.mkForce false;
      systemd-boot.enable = lib.mkForce true;
      efi.canTouchEfiVariables = true;
    };

    # comment this if something's fucked up
    # kernelPackages = cachyosKernels.linuxPackages-cachyos-bore-lto;

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
