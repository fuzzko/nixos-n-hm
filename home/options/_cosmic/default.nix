{
  config,
  osConfig ? null,
  lib,
  pkgs,
  ...
}:
let
  homeLib = config.lib;
  enable = false;
in
lib.optionalAttrs (enable || (osConfig != null && osConfig.services.desktopManager.cosmic.enable)) {
  xdg.configFile."cosmic".source = homeLib.file.mkOutOfStoreSymlink (toString ./config);

  home.packages = with pkgs; [
    cosmic-ext-tweaks
    cosmic-ext-applet-external-monitor-brightness
    cosmic-ext-applet-privacy-indicator
    cosmic-ext-applet-caffeine
    cosmic-ext-applet-minimon
  ];
}
