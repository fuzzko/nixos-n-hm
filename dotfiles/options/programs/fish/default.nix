{ pkgs, ... }:
{
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      zoxide init fish | source
      source ${builtins.toString ./etc/lscolors.fish}

      set fzf_preview_dir_cmd "eza --all --color=always --icons=always"

      set fish_cursor_default block
      set fish_cursor_insert line
      set fish_cursor_replace_one underscore
      set fish_cursor_replace underscore
      set fish_cursor_visual block

      # disable the stupid autosuggestion
      set fish_autosuggestion_enabled 0

      fish_default_key_bindings -M insert
      fish_vi_key_bindings --no-erase insert

      alias ftodo "ig TODO"
    '';
    plugins =
      map
        (x: {
          name = x.pname;
          inherit (x) src;
        })
        (
          with pkgs.fishPlugins;
          [
            done
            colored-man-pages
            autopair
            git-abbr
            puffer
            fzf-fish
            forgit
          ]
        );
  };
}
