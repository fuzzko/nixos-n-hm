{ config, ... }:
{
  services.git-sync.enable = true;
  services.git-sync = {
    repositories."nix" = {
      path = "${config.home.homeDirectory}/nix";
      uri = "https://github.com/mbekkomo/nix.git";
    };
    repositories."password-store" = {
      path = "${config.home.homeDirectory}/.local/share/password-store";
      uri = "https://github.com/mbekkomo/.password-store";
    };
  };
}
