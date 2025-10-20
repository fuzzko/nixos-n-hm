{ lib, ... }: {
  services.kanata.enable = lib.mkForce false;

  boot.kernelParams = [
    "ath9k.nohwcrypt=1"
  ];

  networking.networkmanager.settings = {
    device = {
      match-device = "interface-name:wlan0";
      carrier-wait-timeout = 10000;
      ignore-carrier = true;
    };
  };
}
