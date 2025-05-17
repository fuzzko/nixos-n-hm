{ config, ... }:
{
  user =
    let
      inherit (config.program.git) userName userEmail;
    in
    {
      name = userName;
      email = userEmail;
    };

  ui = {
    diff-formatter = "riff";
  };

  merge-tools.riff = {
    diff-args = [
      "--color=on"
      "$left"
      "$right"
    ];
  };
}
