lib:
let
  inherit (builtins)
    filter
    readDir
    readFile
    fromJSON
    split
    typeOf
    concatStringsSep
    mapAttrs
    elemAt
    length
    ;
in
rec {
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

  # wraps list of packages or attrs
  wrapFishPlugins =
    x:
    map (
      p:
      if lib.isDerivation p then
        {
          name = p.name;
          src = p;
        }
      else
        p
    ) x;

  # parses a yaml
  fromYAML =
    pkgs: yaml:
    let
      yamlFile = pkgs.writeText "file.yaml" yaml;
      jsonFile = pkgs.runCommand "yaml.json" { } ''
        ${pkgs.yj}/bin/yj < ${yamlFile} > $out
      '';
    in
    fromJSON (readFile jsonFile);

  trimEveryLineWith =
    attrs: s:
    let
      lines =
        let
          matches = split "([^\n]+)" s;
          filtered = filter (l: typeOf l == "list") matches;
          normalized = lib.flatten filtered;
        in
        normalized;
      trimmed = map (s: lib.trimWith attrs s) lines;
      joined = concatStringsSep "\n" trimmed;
    in
    joined;

  trimEveryLine = trimEveryLineWith {
    start = true;
    end = true;
  };

  getFlakeInputGithub =
    s:
    let
      flakeLock = fromJSON (readFile ../flake.lock);
      input = flakeLock.nodes.${s};
    in
    assert input.locked.type == "github";
    input;

  fromBoolToNumStr = b: if b then "1" else "0";

  hypr = {
    mkBeziers =
      attrs:
      mapAttrs (
        bezierName: xys:
        assert length xys == 4;
        let
          xys' = map toString xys;
        in
        "${bezierName}, ${elemAt xys' 0}, ${elemAt xys' 1}, ${elemAt xys' 2}, ${elemAt xys' 3}"
      ) attrs;

    mkAnimations =
      attrs:
      mapAttrs (
        animName: option:
        "${animName},"
        + "${fromBoolToNumStr (option.enable or true)},"
        + "${toString option.speed},"
        + "${option.curve}"
        + (if option ? style then ",${option.style}" else "")
      ) attrs;

    percentXY = x: y: "${toString x}%, ${toString y}%";

    rgb = r: g: b: "rgb(${toString r}, ${toString g}, ${toString b})"
  };
}
