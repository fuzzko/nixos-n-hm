{ configs, ... }:
{
  user =
    let
      inherit (configs.program.git) userName userEmail;
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
