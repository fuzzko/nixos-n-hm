{ osConfig ? null, ... }:
let
in
{
  targets.genericLinux.enable = osConfig == null;
  targets.genericLinux.nixGL = {
    
  };
}
