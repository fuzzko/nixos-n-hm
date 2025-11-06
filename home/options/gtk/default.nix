{ pkgs, ... }:
{
  gtk.enable = true;
  gtk = {
    colorScheme = "dark";
  };

  gtk.theme = {
    name = "Adwaita-dark";
  };
  gtk.gtk3.theme = {
    package = pkgs.adw-gtk3;
    name = "adw-gtk3-dark";
  };
}
