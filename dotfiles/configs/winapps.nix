{ ... }: {
  RDP_USER = "MyWindowsUser";
  RDP_PASS = "MyWindowsPassword";
  RDP_DOMAIN = "";
  RDP_IP = "127.0.0.1";
  RDP_SCALE = 100;
  RDP_FLAGS = "/cert:tofu /sound /microphone /network:lan";
  FREERDP_COMMAND = "";
  WAFLAVOR = "podman";
  MULTIMON = false;
  DEBUG = false;
  AUTOPAUSE = "on";
  AUTOPAUSE_TIMEOUT = 300;
}
