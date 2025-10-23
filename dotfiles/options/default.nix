# any options that does not need to have it's own dir
{ ... }: {
  caches.cachix = [
    "nix-community"
    "0komo"
  ];
}
