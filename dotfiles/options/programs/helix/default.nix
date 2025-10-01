{ lib, pkgs, ... }:
{
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
    languages = loadConfig "helix/languages" { };
  };
  programs.helix.settings = {
    theme = lib.mkForce "ao";

    editor = {
      true-color = true;
      mouse = false;
      scroll-lines = 2;
      line-number = "relative";
      cursorline = true;
      bufferline = "multiple";
      color-modes = true;
      default-line-ending = "lf";
      popup-border = "all";
      preview-completion-insert = false;
      completion-trigger-len = 2;
      shell = [
        "nu"
        "--stdin"
        "-c"
      ];
    };

    editor.statusline = {
      mode = {
        normal = "NOR";
        insert = "INS";
        select = "SEL";
      };
      center = [
        "read-only-indicator"
        "file-base-name"
        "file-modification-indicator"
      ];
      left = [
        "mode"
        "spacer"
        "spinner"
        "spacer"
        "diagnostics"
      ];
      right = [
        "file-type"
        "file-encoding"
        "position"
        "version-control"
      ];
    };

    editor.indent-guides = {
      render = true;
      character = "╎";
    };

    editor.soft-wrap = {
      enable = true;
      max-wrap = 25;
      max-indent-retain = 0;
    };

    editor.end-of-line-diagnostics = "warning";
    editor.inline-diagnostics = {
      cursor-line = "error";
    };

    keys.normal = {
      "C-m" = {
        s = "save_selection";
        "." = "jump_forward";
        "," = "jump_backward";
      };
    };
  };
}
