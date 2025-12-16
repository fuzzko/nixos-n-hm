{ ... }: {
  programs.fzf.enable = true;
  programs.fzf.defaultCommand = "fd --type f";
  programs.fzf.defaultOptions = [
    "--reverse"
    "--cycle"
    "--pointer=>"
    "--marker=|"
    "--list-border=sharp"
    "--input-border=bold"
  ];
  programs.fzf.fileWidgetCommand = "fd --type f --strip-cwd-prefix --hidden --follow --exclude .git";
  programs.fzf.fileWidgetOptions = [
    "--list-border=none"
    "--input-border=line"
  ];
}
