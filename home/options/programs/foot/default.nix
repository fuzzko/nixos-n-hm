{ pkgs, ... }:
{
  programs.foot.enable = true;
  programs.foot = {
    settings = {
      main = {
        shell = "fish";
        login-shell = true;

        font = "GohuFont 14 Nerd Font:size=11";
      };
      bell.system = false;
    };
  };

  home.packages = with pkgs; [
    nerd-fonts.gohufont
  ];
}
