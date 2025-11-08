{ pkgs, config, ... }:
let
  inherit (config.lib) komo;
  inherit (builtins)
    readFile
    fromJSON
    ;
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
      (pkgs.fetchFromGitHub {
        owner = "sshilovsky";
        repo = "fish-helix";
        rev = "8a5c7999ec67ae6d70de11334aa888734b3af8d7";
        hash = "sha256-04cL9/m5v0/5dkqz0tEqurOY+5sDjCB5mMKvqgpV4vM=";
      })
    ]
  );

  programs.fish.shellAbbrs = {
    nixs = "nix-search";
  };

  programs.fish.shellAliases = {
    fztodo = "ig TODO";
    fzhx = "hx .";
    cdt = "cd (mktemp -d)";
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

    with-nxs = ''
      set tempfile (mktemp)
      echo $argv[2..] > $tempfile
      nxs $argv[1] --command "fish $tempfile"
    '';

    with-nxd = ''
      set tempfile (mktemp)
      echo $argv[2..] > $tempfile
      nxd $argv[1] --command "fish $tempfile"
    '';

    komo_modified_when = ''
      set now (begin
        set tmp (date +"%s
                  %H
                  %M
                  %S")
        math "$tmp[1] - ($tmp[2] * 3600) - ($tmp[3] * 60) - $tmp[4]"
      end)
      set file_date (begin
        set tmp (date -r $argv[1] +"%s
                  %H
                  %M
                  %S")
        math "$tmp[1] - ($tmp[2] * 3600) - ($tmp[3] * 60) - $tmp[4]"
      end)
      math "($now - $file_date) / 86400"
    '';

    komo_cache_or_get = ''
      set filename $argv[1]

      if ! test -f $filename; or test (komo_modified_when $filename) -gt 0
        command $argv[2..] > $filename
      end

      cat $filename
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
            -- fish -c \
              komo_cache_or_get ~/.cache/wttr.in curl -s wttr.in/Kendari?1)
      else if test $SHLVL -eq 1
        gum format -- "> *no weather report for today...*"
      end
    '';

    fish_title = ''
      set -q argv[1]; or set argv fish
      echo (fish_prompt_pwd_dir_length=1 prompt_pwd): $argv;
    '';
  };

  programs.fish.interactiveShellInit = ''
    source ${
      let
        input = komo.getGithubFlakeInput "ls_colors";
      in
      (pkgs.fetchFromGitHub {
        inherit (input.locked) owner repo rev;
        hash = input.locked.narHash;
      })
      + /lscolors.csh
    }

    set fzf_preview_dir_cmd "eza --all --color=always --icons=always"

    set fish_cursor_default block
    set fish_cursor_insert line
    set fish_cursor_replace_one underscore
    set fish_cursor_replace underscore
    set fish_cursor_visual block

    # disable the stupid autosuggestion
    set fish_autosuggestion_enabled 0

    fish_helix_key_bindings
  '';

  ## extra clis

  home.packages = with pkgs; [
    gum
    glow
    gut
  ];

  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;

  programs.eza.enable = true;
  programs.eza = {
    theme =
      let
        themeName = "frosty";

        lock = fromJSON (readFile ../../../../flake.lock);
        info = lock.nodes.eza-themes.locked;
        src = pkgs.fetchFromGitHub {
          inherit (info)
            owner
            repo
            rev
            ;
          hash = info.narHash;
        };
      in
      komo.fromYAML pkgs (readFile "${src}/themes/${themeName}.yml");

    icons = true;
    colors = "auto";
    extraOptions = [
      "--classify=auto"
      "--sort=type"
      "--git-ignore"
      "--git"
      "--header"
    ];
  };

  programs.ripgrep.enable = true;
  programs.ripgrep.arguments = [
    "--smart-case"
    "--ignore"

    "--context=2"
    "--color=auto"
    "--colors=match:fg:black"
    "--colors=match:bg:red"
    "--field-context-separator=: "
    "--field-match-separator=: "
    "--trim"
    "--heading"
    "--line-number"
  ];

  programs.fd.enable = true;
  programs.fd.extraOptions = [
    "--glob"
    "--ignore-vcs"
  ];

  programs.fzf.enable = true;
  programs.fzf.defaultCommand = "fd --type f";
  programs.fzf.defaultOptions = [
    "--reverse"
    "--cycle"
    "--pointer=>"
    "--marker=|"
    "--list-border=sharp"
    "--input-border=bold"
  ];
  programs.fzf.fileWidgetCommand = "fd --type f --strip-cwd-prefix --hidden --follow --exclude .git";
  programs.fzf.fileWidgetOptions = [
    "--list-border=none"
    "--input-border=line"
  ];

  programs.zoxide.enable = true;

  home.sessionVariables = {
    _ZO_ECHO = 1;
    _ZO_FZF_OPTS = builtins.concatStringsSep " " [ ];
  };
}
