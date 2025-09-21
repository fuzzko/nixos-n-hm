# Utils for Niri config
let
  inherit (builtins)
    listToAttrs
    ;
in
{
  # TODO: replace `matches.*` with smth like `matches { app-id = ...; title = [ ... ]; }`

  # a lambda that generates an attr for `matches` option
  window-rules.matches =
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

  spawn-at-startup = {
    # wrapper for `argv`, behaves like actions.spawn
    spawn = {
      argv = [ ];
      __functor =
        self: arg:
        self
        // {
          argv = self.argv ++ [ arg ];
        };
    };
    # wrapper for `sh`, behaves like actions.spawn-sh
    spawn-sh = sh: { inherit sh; };
  };
}
