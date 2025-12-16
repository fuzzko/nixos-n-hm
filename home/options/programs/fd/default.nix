{ ... }:
{
  programs.fd.enable = true;
  programs.fd.extraOptions = [
    "--glob"
    "--ignore-vcs"
  ];
}
