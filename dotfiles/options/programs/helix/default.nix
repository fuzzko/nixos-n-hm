{ ... }: {
  
  programs.helix = {
    enable = true;
    package = pkgs.helix_git;
    defaultEditor = true;
    extraPackages = lib.flatten (
      with pkgs;
      [
        nushell

        nixfmt-rfc-style
        nil

        fnlfmt
      ]
    );
    settings = loadConfig "helix/config" { };
    languages = loadConfig "helix/languages" { };
  };
}
