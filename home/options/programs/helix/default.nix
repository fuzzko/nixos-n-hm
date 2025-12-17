{
  lib,
  pkgs,
  npins,
  ...
}:
{
  programs.helix = {
    enable = true;
    package = pkgs.callPackage "${npins.helix}" { };
    defaultEditor = true;
    extraPackages = lib.flatten (
      with pkgs;
      [
        nushell
        nixfmt-rfc-style
        nixd
      ]
    );
  };

  programs.helix.languages = {
    language = [
      {
        name = "html";
        roots = [ ".git" ];
        language-servers = [
          "emmet-langserver"
          "superhtml"
        ];
      }
    ];

    grammar = [
      {
        name = "fennel";
        source = {
          path =
            (builtins.fetchGit {
              url = "https://github.com/0komo/tree-sitter-fennel.git";
              ref = "merged";
            }).outPath;
        };
      }
    ];
  };

  programs.helix.themes.autumn_night_transparent = {
    inherits = "autumn_night";
    "ui.background" = { };
  };

  programs.helix.settings.theme = "autumn_night_transparent";
  programs.helix.settings.editor = {
    true-color = true;

    mouse = false;

    scroll-lines = 2;
    line-number = "relative";

    cursor_shape.insert = "underline";
    cursor_shape.select = "hidden";
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

    statusline = {
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

    indent-guides = {
      render = true;
      character = "╎";
      skip-levels = 1;
    };

    soft-wrap = {
      enable = true;
      max-wrap = 25;
      max-indent-retain = 0;
    };

    end-of-line-diagnostics = "error";
    inline-diagnostics = {
      cursor-line = "warning";
      other-lines = "hint";
    };

    file-explorer = {
      follow-symlinks = true;
      ignore = true;
      git-ignore = true;
      git-exclude = true;
    };

    word-completion.trigger-length = 4;
  };

  programs.helix.settings.keys.normal = {
    "C-m" = {
      s = "save_selection";
      "." = "jump_forward";
      "," = "jump_backward";
    };
  };
}
