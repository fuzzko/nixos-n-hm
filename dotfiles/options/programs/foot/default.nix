{ ... }:
{
  enable = true;
  settings = loadConfig' "foot" { };
  server.enable = true;
}
