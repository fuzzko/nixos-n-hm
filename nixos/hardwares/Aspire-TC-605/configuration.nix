{ lib, ... }:
{
  imports = [
    ./hardware-configuration.nix
  ];
  
  services.kanata.enable = lib.mkForce false;

  networking.networkmanager = {
    wifi.powersave = false;
    wifi.scanRandMacAddress = false;
  };
}
