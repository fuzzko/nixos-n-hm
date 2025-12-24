{ config, lib, ... }:
let
  cfg = config.programs.nushell.overlays;

  overlaySubmodule = {
    options = {
      enable = lib.mkEnableOption "the overlay" // {
        default = true;
        example = false;
      };

      module = lib.mkOption {
        type = with lib.types; either str path;
        example = lib.literalExpression "./foo.nu";
        description = "Module or path of the overlay.";
      };

      prefix = lib.mkOption {
        type = with lib.types; bool;
        default = false;
        example = true;
        description = "Whether to prepend module name to the imported commands and aliases.";
      };
    };
  };
in
{
  options = {
    programs.nushell.overlays = lib.mkOption {
      type = with lib.types; attrsOf (submodule overlaySubmodule);
      default = { };
      example = lib.literalExpression ''
        {
          foo = {
            module = "foo";
            prefix = false;
          };
        }
      '';
      description = "An attribute set of overlays definition (the top level attribute names in the option being the overlay name).";
    };
  };

  config.programs.nushell.extraConfig =
    let
      describeCfg =
        attr:
        lib.mapAttrs (
          name: subcfg:
          "overlay use ${lib.optionalString subcfg.prefix "--prefix"} \"${subcfg.module}\" as ${name}"
        ) attr
        |> lib.attrValues;
    in
    cfg |> describeCfg |> lib.concatLines;
}
