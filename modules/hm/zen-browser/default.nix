{
  pkgs,
  lib,
  npins ? null,
  ...
}:
if npins != null then
  let
    makeFirefoxModule = import "${npins.home-manager}/modules/programs/firefox/mkFirefoxModule.nix";

    module = makeFirefoxModule {
      modulePath = "programs.zen-browser";
      wrappedPackage = "zen-browser";
      visible = true;

      platforms.linux.configPath = ".zen";
    };
  in
  {
    imports = [
      module
    ];

    config = {
      assertions = [
        (lib.hm.assertions.assertPlatform "programs.zen-browser" pkgs lib.platforms.linux)
        {
          assertion = pkgs ? zen-browser && pkgs ? zen-browser-unwrapped;
          message = ''programs.zen-browser "package" option require pkgs.zen-browser to be available'';
        }
      ];
    };
  }
else
  { }
