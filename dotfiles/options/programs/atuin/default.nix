{ ... }: {
  programs.atuin.enable = true;

  programs.atuin.settings = {
    search_syntax = "fuzzy";
    filter_mode = "workspace";
    style = "full";
    enter_accept = true;
  };
}
