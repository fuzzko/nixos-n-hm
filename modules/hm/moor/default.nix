{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.programs.moor = {
    enable = lib.mkEnableOption "moor";

    package = lib.mkPackageOption pkgs (if pkgs ? moor then "moor" else "moar") {
      description = "Which package to use for installing moor";
      nullable = true;
    };

    extraOptions = lib.mkOption {
      type = with lib.types; listOf str;
      description = "Extra command line options passed to moor";
      default = [ ];
      example = [
        "--statusbar=bold"
        "--no-linenumbers"
      ];
    };
  };

  config =
    let
      cfg = config.programs.moor;
    in
    lib.mkIf cfg.enable {
      home.packages = lib.mkIf (cfg.package != null) [ cfg.package ];

      home.sessionVariables = {
        "${if (lib.compareVersions cfg.package.version "2.0.0") < 1 then "MOAR" else "MOOR"}" =
          lib.concatStringsSep " " cfg.extraOptions;
      };

    };
}
