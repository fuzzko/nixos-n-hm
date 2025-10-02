{ config, lib, pkgs, ... }:
{
  options.programs.moor = {
    enable = lib.mkEnableOption "moor";
    package = lib.mkPackageOption pkgs "moor" {
      description = "Which package to use for installing moor";
      nullable = true;
    };
    extraOptions = lib.mkOption {
      type = with lib.types; listOf str;
      description = "Extra command line options passed to moor";
      default = [];
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
      home.sessionVariables = {
        "MOOR" = lib.concatStringsSep " " cfg.extraOptions;
      };

      home.packages = lib.mkIf (cfg.package != null) [ cfg.package ];
    };
}
