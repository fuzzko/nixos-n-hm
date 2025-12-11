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
    pathExists
    replaceStrings
    attrNames
    attrValues
    listToAttrs
    ;

  npins = import ../npins;

  flake-compat = import npins.flake-compat;
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

  # get a flake outputs from npin
  getFlakeFromNpin = npin: (flake-compat { src = npin.outPath; }).outputs;

  # filters npins and turn them into flakes outputs
  npinsToFlakes =
    npins:
    let
      npinNames = attrNames npins;
      filteredNpins = filter (
        name:
        let
          npin = npins.${name};
        in
        pathExists "${npin}/flake.nix"
      ) npinNames;
      transformedNpins = listToAttrs (
        map (
          name:
          let
            npin = npins.${name};
          in
          {
            inherit name;
            value = (flake-compat { src = npin.outPath; }).outputs;
          }
        ) filteredNpins
      );
    in
    transformedNpins;

  # poor man's modification of lib.nixosSystem
  nixosSystem =
    pkgs: args:
    import "${pkgs.path}/nixos/lib/eval-config.nix" (
      {
        inherit (pkgs) lib;
        inherit (pkgs.stdenv.hostPlatform) system;

        modules = args.modules ++ [
          (attrs: {
            config.nixpkgs = {
              inherit pkgs;
            };
          })
        ];
      }
      // removeAttrs args [ "modules" ]
    );

  # product name of current system
  systemProductName =
    let
      path = /sys/devices/virtual/dmi/id/product_name;
      rawName = if pathExists path then readFile path else null;
      name = if rawName != null then replaceStrings [ " " ] [ "-" ] rawName else null;
    in
    name;

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

  getPathFromPwd = path: toString /${builtins.getEnv "PWD"}/${path};

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

    rgb =
      r: g: b:
      "rgb(${toString r}, ${toString g}, ${toString b})";

    textCmd = updateMs: cmd: "cmd[update:${toString updateMs}] ${cmd}";
  };
}
