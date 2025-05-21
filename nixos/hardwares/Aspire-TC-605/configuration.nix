{ lib, ... }: {
  services.kanata.enable = lib.mkForce false;
}
