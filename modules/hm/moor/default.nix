{ config, lib, pkgs, ... }:
let
  cfg = config.programs.moor;
in
{
  programs.moor = {
    enable = lib.mkEnableOption "moor";
    package = lib.mkPackageOption pkgs "moor" {
      description = "Which package to use for installing moor";
    };
    extraOptions = lib.mkOption {
      type = with lib.types; listOf str;
    };
  };
}
