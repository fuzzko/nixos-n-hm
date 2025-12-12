{pkgs, ...}: {  services.kmscon.enable = true;
  services.kmscon = {
    autologinUser = "komo";
    useXkbConfig = true;
    hwRender = true;
    extraConfig = ''
      listen
      font-size=11
      mouse
      palette=soft-black
    '';
    fonts = [
      {
        name = "GohuFont 14 Nerd Font";
        package = pkgs.nerd-fonts.gohufont;
      }
    ];
  };

}
