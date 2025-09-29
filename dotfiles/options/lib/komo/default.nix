{ lib, ... }: {
  komo = rec {
      filesInDir =
        dir:
        let
          go =
            list: path:
            lib.mapAttrsToList (
              basename: type: if type == "directory" then go list (path + /${basename}) else path + /${basename}
            ) (builtins.readDir path);
        in
        lib.flatten (go [ ] dir);
      filterFilesInDir = filterLambda: dir: builtins.filter filterLambda (filesInDir dir);
  };
}
