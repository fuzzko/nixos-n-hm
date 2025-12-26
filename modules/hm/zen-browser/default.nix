{
  pkgs,
  lib,
  ...
}:
let
  npins = import ../../../npins;
  makeFirefoxModule = import "${npins.home-manager}/modules/programs/firefox/mkFirefoxModule.nix";

  module = makeFirefoxModule {
    modulePath = "programs.zen-browser" |> (lib.splitString ".");
    name = "Zen Browser";
    wrappedPackageName = "zen-browser";
    visible = true;

    platforms.linux.configPath = ".zen";
    platforms.darwin = {
      configPath = "";
      defaultsId = "";
    };
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
        assertion = pkgs ? zen-browser;
        message = ''programs.zen-browser "package" option require pkgs.zen-browser to be available'';
      }
    ];
  };
}
