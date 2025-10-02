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
      home.packages = lib.singleton cfg.package;

      home.sessionVariables = {
        "${lib.toUpper cfg.package.name}" =
          lib.concatStringsSep " " cfg.extraOptions;
      };

    };
}
