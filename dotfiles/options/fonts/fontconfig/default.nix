{ pkgs, ... }: {
  fonts.fontconfig.enable = true;
  fonts.fontconfig = {
    defaultFonts = {
      monospace = "";
    };
  };

  home.packages = with pkgs; [
    nerd-fonts.gohufont
  ];
}
