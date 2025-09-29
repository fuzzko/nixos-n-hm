{ lib, ... }:
let
  inherit (builtins)
    filter
    readDir
    ;
in
{
  lib.komo = rec {
    # returns a list of files inside a directory
    # cannot follows symlink due to lacking of readlink utility
    filesInDir =
      dir:
      let
        go =
          list: path:
          lib.mapAttrsToList (
            basename: type: if type == "directory" then go list (path + /${basename}) else path + /${basename}
          ) (readDir path);
      in
      lib.flatten (go [ ] dir);
    # same as `filter (p: ...) (filesInDir path)`
    filterFilesInDir = filterLambda: dir: filter filterLambda (filesInDir dir);
  };
}
