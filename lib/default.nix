{ pkgs }:
{
  execWith = cmd: deps: builtins.readFile (pkgs.runCommand "" { buildInputs = deps; } "${cmd}>$out");
  transpileToCSS = path: execWith "";
}
