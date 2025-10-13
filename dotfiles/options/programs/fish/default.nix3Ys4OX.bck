{ pkgs, config, ... }:
let
  inherit (config.lib) komo;

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
  programs.fish.plugins = komo.wrapFishPlugins (
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

  programs.fish.shellAliases = {
    ftodo = "ig TODO";
  };

  programs.fish.functions = {
    nxs = ''
      if contains -- --command $argv
        nix shell $argv
      else
        nix shell $argv --command fish
      end
    '';

    nxd = ''
      if contains -- --command $argv
        nix develop $argv
      else
        nix develop $argv --command fish
      end
    '';

    modified_when = ''
      set now (date +%s)
      set file_date (date -r $argv[1] +%s)
      math "round(($now - $file_date) / 86400)"
    '';
  };

  # fish_* related functions
  programs.fish.functions = {
    fish_greeting = ''
      if test $SHLVL -eq 1
        gum format -- "> welcome back *$USER*, it's currently $(date +"*%A* (%d/%m) at *%I:%M %P*")"
      else
        gum format -- "> welcome back *$USER*, your current shell level is **$SHLVL**!
          ...be careful down there!"
      end
      if nc -vz wttr.in 443 >/dev/null 2>&1; and test $SHLVL -eq 1
        gum style \
          --border=double \
          --margin='0 3' \
          --padding='0 2' \
          --border-foreground=26 \
          (gum spin \
            --spinner.foreground=31 \
            --spinner=dot \
            --title="getting weather report..." \
            -- curl -s wttr.in/Kendari?1)
      else if test $SHLVL -eq 1
          gum format -- "> *no weather report for today...*"
      end    '';

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
