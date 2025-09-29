{ ... }:
{
  programs.foot.enable = true;
  programs.foot = {
    settings = {
      main = {
        shell = "fish";
        login-shell = true;

        font = "DepartureMono Nerd Font Mono:size=10";
      };
      bell.system = false;
    };

    server.enable = true;
  };
}
