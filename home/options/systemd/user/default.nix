{ config, lib, ... }:
{
  systemd.user.enable = true;
  systemd.user.startServices = false;
}
