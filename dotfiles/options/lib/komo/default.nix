{ lib, ... }:
let
  inherit (builtins)
    filter
    readDir
    ;
in {
  komo = rec {
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
      filterFilesInDir = filterLambda: dir: filter filterLambda (filesInDir dir);
  };
}
