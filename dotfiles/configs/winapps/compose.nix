{ ... }:
let
  username = "MyWindowsUser";
  password = "MyWindowsPassword";

  windows_version = "10l";
  ram_size = "2G";
  cpu_cores = "2";
  disk_size = "64G";
in
{
  name = "winapps";
  volumes.data = {};
  services.windows = {
    image = "ghcr.io/dockur/windows:latest";
    container_name = "WinApps";
    environment = {
      "VERSION" = windows_version;
      "USERNAME" = username;
      "PASSWORD" = password;
      "RAM_CHECK" = "N"; # fix quirky issue with detecting RAM
      "RAM_SIZE" = ram_size;
      "CPU_CORES" = cpu_cores;
      "DISK_SIZE" = disk_size;
      "HOME" = "\${HOME}";
    };
  };
}
