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
}
