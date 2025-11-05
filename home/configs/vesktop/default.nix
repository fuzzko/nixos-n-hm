{ config, ... }: {
  discordBranch = "stable";
  transparencyOption = "none";
  tray = true;
  minimizeToTray = true;
  staticTitle = true;
  customTitleBar = false;
  clickTrayToShowHide = true;
  arRPC = config.services.arrpc.enable;
  hardwareAcceleration = true;
  appBadge = true;

  enableSplashScreen = true;

  audio.deviceSelect = true;
}
