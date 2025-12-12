{ pkgs, ... }: {
  fonts.fontDir.enable = true;
  fonts.packages = with pkgs; [
    nerd-fonts.gohufont
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
  ];
}
