{ ... }:
{
  programs.atuin.enable = false;

  programs.atuin.settings = {
    search_syntax = "fuzzy";
    filter_mode = "workspace";
    style = "full";
    enter_accept = true;
  };
}
