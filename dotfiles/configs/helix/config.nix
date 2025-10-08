{ pkgs, lib, ... }:
{
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
  };

  editor.shell = [
    "nu"
    "--stdin"
    "-c"
  ];

  editor.cursor-shape = {
    insert = "underline";
  };

  editor.statusline = {
    mode = {
      normal = "NORMAL";
      insert = "INSERT";
      select = "SELECT";
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
    skip-levels = 1;
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
    C-m = {
      s = "save_selection";
      "." = "jump_forward";
      "," = "jump_backward";
    };
    tab = "move_parent_node_end";
    S-tab = "move_parent_node_start";
  };
}
