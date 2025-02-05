{ pkgs }:
rec {
  execWith = cmd: deps: builtins.readFile (pkgs.runCommand "" { buildInputs = deps; } "${cmd}>$out");
  transpileToCSS = path: execWith "sass -s compressed ${path}" (with pkgs; [ dart-sass ]);
}
