{ osConfig ? null, ... }:
{
  targets.genericLinux.enable = osConfig == null;
}
