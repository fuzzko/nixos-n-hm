{ pkgs, ... }:
let
  flakeLock = builtins.fromJSON (builtins.readFile ../../../../flake.lock);

  lsColors =
    let
      info = flakeLock.node.ls_colors.locked;
    in
    pkgs.fetchFromGitHub {
      inherit (info)
        owner
        repo
        rev
        ;
    };
in
{
  programs.fish.enable = true;
  programs.fish = {
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

  programs.fish.shellAliases = {
    ftodo = "ig TODO";
  };

  programs.fish.functions = {
    fish_greeting = ''
      cat ${toString ./logo.raw}
    '';

    fish_title = ''
    set -q argv[1]; or set argv fish
    echo (fish_prompt_pwd_dir_length=1 prompt_pwd): $argv;
    '';
  };

  programs.fish.interactiveShellInit = ''
    source ${lsColors}/lscolors.csh

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
  '';
}
