{ lib, ... }: {
  services.kanata.enable = lib.mkForce false;

  networking.networkmanager = {
    wifi.powersave = false;
    wifi.scanRandMacAddress = false;
    wifi.macAddress = "stable-ssid";
  };
}
