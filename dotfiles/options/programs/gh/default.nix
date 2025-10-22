{ pkgs, ... }: {
  programs.gh.enable = true;
  programs.gh.extensions = with pkgs; [
      gh-poi
      gh-eco
      gh-screensaver
      gh-s
      gh-f
      gh-notify
      gh-markdown-preview
  ];
}
