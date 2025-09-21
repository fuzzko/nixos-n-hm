# Utils for Niri config
let
  inherit (builtins)
    listToAttrs
    ;

  fromListToTaggedUnion =
    xs:
    listToAttrs (
      (map (x: {
        name = x;
        value = a: { "${x}" = a; };
      }) xs)
    );
in
{
  # TODO: replace `matches.*` with smth like `matches { app-id = ...; title = [ ... ]; }`

  animations.kind = fromListToTaggedUnion [
    "easing"
    "spring"
  ];

  animations.mkCurveArgs = a: b: c: d: [a b c d];

  # lambdas to create a tagged union for `matches` option
  window-rules.matches = fromListToTaggedUnion [
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
      __functor = self: arg: {
        inherit (self) __functor;
        argv = self.argv ++ [ arg ];
      };
    };
    # wrapper for `sh`, behaves like actions.spawn-sh
    spawn-sh = sh: { inherit sh; };
  };
}
