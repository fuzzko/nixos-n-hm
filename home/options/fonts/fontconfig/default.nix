{ pkgs, ... }:
{
  fonts.fontconfig.enable = true;
  fonts.fontconfig = {
    defaultFonts.emoji = [ "Noto Color Emoji" ];
  };

  home.packages = with pkgs; [
    noto-fonts
    noto-fonts-color-emoji
  ];
}
