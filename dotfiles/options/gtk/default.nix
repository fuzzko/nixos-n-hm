{ pkgs, ... }:
{
  gtk.enable = true;
  gtk.theme = {
    theme = "Adwaita-dark";
  };
  gtk.gtk3.theme = {
    package = pkgs.adw-gtk3;
    theme = "adw-gtk3";
  };
}
