{ ... }:
{
  services.syncthing.enable = true;
  services.syncthing = {
    user = "komo";
    dataDir = "/home/komo";
    openDefaultPorts = true;
  };
}
