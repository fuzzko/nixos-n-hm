_: {
  language-server.nil = {
    config = {
      nil.formatting.command = [ "nixfmt" ];
    };
  };

  language-server.emmet-langserver = {
    command = "emmet-language-server";
    args = [ "--stdio" ];
  };
  language-server.ccls.command = "ccls";
  language-server.superhtml = {
    command = "superhtml";
    args = [ "lsp" ];
  };
  language-server.tailwindcss-langserver = {
    command = "tailwindcss-language-server";
    args = [ "--stdio" ];
    required-root-patterns = [ "tailwind.config.js" ];
  };
  language-server.emmylua = {
    command = "emmylua_ls";
    args = [
      "--log-path"
      "/tmp/emmylua_ls"
    ];
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
        name = "lua";
        roots = [
          ".editorconfig"
          ".luarc.json"
          ".emmyrc.json"
          ".busted"
          ".luacheckrc"
          ".stylua.toml"
          "selene.toml"
          ".git"
        ];
        language-servers = [
          "emmylua"
        ];
      }
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
        name = "c";
        language-servers = [ "ccls" ];
      }
      {
        name = "cpp";
        language-servers = [ "ccls" ];
      }
    ];
}
