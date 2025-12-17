{ npins, ... }:
{
  users.users.komo = {
    isNormalUser = true;
    description = "Komo";
    extraGroups = [
      "networkmanager"
      "wheel"
      "video"
      "i2c"
    ];
  };

  home-manager.useGlobalPkgs = true;
  home-manager.users.komo = { ... }: {
    imports = [
      ({ ... }: {
        _module.args.npins = npins;
      })
      ./_home-manager.nix
      ../../../../home/home.nix
    ];
  };
}
