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
        nixd
      ]
    );
  };

  programs.helix.languages = {
    language-server.nil = {
      config = {
        nil.formatting.command = [ "nixfmt" ];
      };
    };

    language-server.emmet-langserver = {
      command = "emmet-language-server";
      args = [ "--stdio" ];
    };
    language-server.superhtml = {
      command = "superhtml";
      args = [ "lsp" ];
    };
    language-server.tailwindcss-langserver = {
      command = "tailwindcss-language-server";
      args = [ "--stdio" ];
      required-root-patterns = [ "tailwind.config.js" ];
    };

    language =
      let
        indent = {
          unit = "  ";
          tab-width = 2;
        };
      in
      [
        {
          name = "html";
          roots = [ ".git" ];
          language-servers = [
            "emmet-langserver"
            "superhtml"
          ];
        }
        {
          inherit indent;

          name = "civet";
          scope = "source.civet";
          file-types = [ "civet" ];
          comment-tokens = "//";
          block-comment-tokens = [
            {
              start = "/*";
              end = "*/";
            }
            {
              start = "###\n";
              end = "\n###";
            }
          ];
        }
        {
          inherit indent;

          name = "nelua";
          scope = "source.nelua";
          file-types = [ "nelua" ];
          comment-tokens = "--";
          block-comment-tokens = {
            start = "--[[";
            end = "]]";
          };
        }
        {
          inherit indent;

          name = "c";
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

  programs.helix.settings.theme = lib.mkForce "ao";
  programs.helix.settings.editor = {
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
  };

  soft-wrap = {
    enable = true;
    max-wrap = 25;
    max-indent-retain = 0;
  };

  end-of-line-diagnostics = "warning";
  inline-diagnostics = {
    cursor-line = "error";
  };

  programs.helix.settings.keys.normal = {
    "C-m" = {
      s = "save_selection";
      "." = "jump_forward";
      "," = "jump_backward";
    };
  };
}
