let
  inherit (builtins)
    listToAttrs
    ;
in
{
  matches =
    listToAttrs
      (
        (map (name: {
          inherit name;
          value = x: { "${name}" = x; };
        }))
      )
      [
        "app-id"
        "title"
        "is-active"
        "is-active-in-column"
        "is-floating"
        "is-focused"
        "is-urgent"
        "is-window-cast-target"
        "at-startup"
      ];
}
