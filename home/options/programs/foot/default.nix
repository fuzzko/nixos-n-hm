{ pkgs, ... }:
{
  programs.foot.enable = true;
  programs.foot.server.enable = true;

  programs.foot.settings = {
    main = {
      shell = "nu -i";
      login-shell = true;

      font = "GohuFont 14 Nerd Font:size=11";
    };

    colors.alpha = .85;

    csd.size = 0; # hide title bar
    
    bell.system = false;
  };

  home.packages = with pkgs; [
    nerd-fonts.gohufont
  ];
}
