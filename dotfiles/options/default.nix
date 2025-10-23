# any options that does not need to have it's own dir
{ pkgs, ... }: {
  caches.cachix = [
    "nix-community"
    "0komo"
  ];

  nixGL = {
    packages = pkgs.nixGLPackages;
    installScripts = [ "mesa" ];
  };
}
