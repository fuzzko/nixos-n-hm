{ ... }:
{
  programs.zoxide.enable = true;

  home.sessionVariables = {
    _ZO_ECHO = 1;
    _ZO_FZF_OPTS = builtins.concatStringsSep " " [ ];
  };
}
