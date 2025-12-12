{ ... }:
{
  users.users.komo = {
    isNormalUser = true;
    description = "Komo";
    extraGroups = [
      "networkmanager"
      "wheel"
      "video"
      "i2c"
    ];
  };

  home-manager.users.komo = import ../../../../home/home.nix;
}
