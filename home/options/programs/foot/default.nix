{ pkgs, ... }:
{
  programs.foot.enable = true;
  programs.foot.server.enable = true;

  programs.foot.settings = {
    main = {
      shell = "nu";

      font = "GohuFont 14 Nerd Font:size=11";
      pad = "0x0 center";

      underline-offset = "3px";
      strikeout-thickness = "2px";
    };

    colors.alpha = 0.85;

    csd.preferred = "client";
    csd.size = 0; # hide title bar
    
    bell.system = false;
  };

  home.packages = with pkgs; [
    nerd-fonts.gohufont
  ];
}
