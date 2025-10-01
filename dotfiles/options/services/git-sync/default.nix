{ config, ... }:
{
  services.git-sync.enable = true;
  services.git-sync.repositories = {
    nix = {
      path = "${config.home.homeDirectory}/nix";
      uri = "https://github.com/0komo/nix.git";
    };
    password-store = {
      path = "${config.home.homeDirectory}/.local/share/password-store";
      uri = "https://github.com/0komo/.password-store";
    };
  };
}
