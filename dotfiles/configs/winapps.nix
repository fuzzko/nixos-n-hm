{ ... }: {
  RDP_USER = "MyWindowsUser";
  RDP_PASS = "MyWindowsPassword";
  RDP_DOMAIN = "";
  RDP_IP = "127.0.0.1";
  WAFLAVOR = "podman";
  RDP_SCALE = 100;
  RDP_FLAGS = "/cert:tofu /sound /microphone /network:lan";
  MULTIMON 
}
