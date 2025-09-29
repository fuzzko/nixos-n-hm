{ pkgs, ... }:
{
  fonts.fontconfig.enable = true;
  fonts.fontconfig = {
  };

  home.packages = with pkgs; [
    nerd-fonts.gohufont
  ];
}
