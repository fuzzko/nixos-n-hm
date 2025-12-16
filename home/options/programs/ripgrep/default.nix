{ ... }:
{
  programs.ripgrep.enable = true;
  programs.ripgrep.arguments = [
    "--smart-case"
    "--ignore"

    "--context=2"
    "--color=auto"
    "--colors=match:fg:black"
    "--colors=match:bg:red"
    "--field-context-separator=: "
    "--field-match-separator=: "
    "--trim"
    "--heading"
    "--line-number"
  ];

}
