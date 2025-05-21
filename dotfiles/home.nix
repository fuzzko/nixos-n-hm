{
  config,
  pkgs,
  lib,
  ...
}@inputs:
let
  username = "komo"; # change to your username
  homeDir = "/home/${username}";
  wrapGL = config.lib.nixGL.wrap;
  # https://github.com/NixOS/nixpkgs/pull/313760#issuecomment-2365160954
  departure-nf = pkgs.departure-mono.overrideAttrs {
    pname = "departure-nerd-font";
    nativeBuildInputs = [ pkgs.nerd-font-patcher ];
    installPhase = ''
      runHook preInstall

      nerd-font-patcher -c *.otf -out $out/share/fonts/otf
      nerd-font-patcher -c *.woff -out $out/share/woff || true
      nerd-font-patcher -c *.woff2 -out $out/share/woff2 || true

      runHook postInstall
    '';
  };

  loadConfig = x: y: import ./configs/${x}.nix (inputs // { root = ./.; } // y);
  loadConfig' = x: y: import ./configs/${x} (inputs // { root = ./.; } // y);
in
{
  programs.home-manager.enable = true;
  home.username = username;
  home.homeDirectory = homeDir;
  home.stateVersion = "24.05"; # do not change

  home.packages = lib.flatten (
    with pkgs;
    [
      # Fonts
      (with nerd-fonts; [
        terminess-ttf
      ])
      departure-nf
      noto-fonts
      noto-fonts-color-emoji

      # Nix-purpose
      nix-search
      cachix

      # Misc.
      micro
      moar
      glow
      libnotify
      unzip
      ueberzugpp
      ouch

      # Something that would ease me off
      (wrapGL nur.repos."0komo".luakit_2_4)
      riff
      khal
      fzf
      ripgrep
      fd
      sd
      zoxide
      bat
      sigi
      gum
      xdragon
      obsidian

      # For hyprland
      nautilus
      nautilus-open-any-terminal
      wluma
      hyprshot
      hyprpicker
      hyprsunset
      hyprsysteminfo
      playerctl
      wireplumber
      clipse
      wl-clipboard
      nushell
      brightnessctl

      # For recording
      kooha
      scrcpy
      mumble

      # i don't fucking know why i installed these shits but i installed them anyway
      youtube-music
      qview
      cinny-desktop
      openutau
      nchat
      (with nur.repos."0komo"; [
        (wrapGL sklauncher)
      ])
    ]
  );

  home.file =
    # External Config
    {
      ".config/zls.json".text = builtins.toJSON (loadConfig "zls" { });
      ".config/walker/config.json".text = builtins.toJSON (loadConfig "walker" { });
      ".config/luakit" = {
        source = ./configs/luakit;
        recursive = true;
      };
      # Misc. files
      ".config/fish/functions/nixs.fish".source = ./shells/nixs.fish;
      ".config/fish/functions/nixd.fish".source = ./shells/nixd.fish;
    };

  home.sessionVariables = rec {
    "XDG_PICTURES_DIR" = "${homeDir}/Pictures";
    "SUDO_PROMPT" = "[sudo 🐺]: ";
    "BROWSER" = "app.zen_browser.zen";
    "PAGER" = "moar";
    "GIT_PAGER" = PAGER;
    "SYSTEMD_PAGERSECURE" = "true";
  };

  home.pointerCursor = {
    enable = true;
    size = 15;
    hyprcursor.enable = true;
    x11.enable = true;
  };

  services.flatpak = {
    enable = true;
    packages = [
      "app.zen_browser.zen"
      "org.vinegarhq.Sober"
    ];
    update.auto = {
      enable = true;
    };
    uninstallUnmanaged = true;
  };

  catppuccin = {
    flavor = "mocha";
    accent = "blue";
    enable = true;

    cursors.enable = true;
    gtk.enable = true;
    fzf.enable = true;
    helix.enable = true;
    fish.enable = true;
    hyprlock.useDefaultConfig = false;
  };

  nix = {
    package = pkgs.lix;
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      allowed-users = [ username ];
      auto-optimise-store = true;
    };
    registry.nixpkgs = {
      from = {
        id = "nixpkgs";
        type = "indirect";
      };
      to = {
        owner = "NixOS";
        repo = "nixpkgs";
        ref = (builtins.fromJSON (builtins.readFile ../flake.lock)).nodes.nixpkgs.locked.rev;
        type = "github";
      };
    };
  };

  nixpkgs.config = {
    allowUnfree = true;
    packageOverrides = pkgs: {
      nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") {
        inherit pkgs;
      };
    };
  };

  nixGL = {
    packages = pkgs.nixGLPackages;
    defaultWrapper = "mesa";
    installScripts = [ "mesa" ];
  };

  programs.password-store = {
    enable = true;
    package = pkgs.pass.withExtensions (
      exts: with exts; [
        pass-otp
        pass-genphrase
        pass-update
        pass-audit
      ]
    );
  };

  services.git-sync = {
    enable = true;
    repositories."nix" = {
      path = "${homeDir}/nix";
      uri = "https://github.com/mbekkomo/nix.git";
    };
    repositories."password-store" = {
      path = "${homeDir}/.local/share/password-store";
      uri = "https://github.com/mbekkomo/.password-store";
    };
  };

  fonts.fontconfig.enable = true;
  fonts.fontconfig.defaultFonts.emoji = [ "Noto Color Emoji" ];

  programs.helix = {
    enable = true;
    package = pkgs.helix_git;
    defaultEditor = true;
    extraPackages = lib.flatten (
      with pkgs;
      [
        nushell

        nixfmt-rfc-style
        shellcheck

        nil
        (with nur.repos."0komo"; [ emmylua_ls ])
        bash-language-server
        emmet-language-server
        yaml-language-server
        vscode-langservers-extracted
        zls
      ]
    );
    settings = loadConfig "helix/config" { };
    languages = loadConfig "helix/languages" { };
    themes.catppuccin-mocha_ts = {
      inherits = "catppuccin-mocha";
      "ui.background" = { };
      "ui.text" = { };
      "ui.linenr".fg = "overlay1";
    };
  };

  programs.foot = {
    enable = true;
    settings = loadConfig' "foot" { };
    server.enable = true;
  };

  programs.bun = {
    enable = true;
  };

  programs.starship = {
    enable = true;
    settings = loadConfig "starship" { };
  };

  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      zoxide init fish | source
      source ${builtins.toString ./etc/lscolors.fish}

      set -Ux fifc_editor bat

      set fish_cursor_default block
      set fish_cursor_insert line
      set fish_cursor_replace_one underscore
      set fish_cursor_replace underscore
      set fish_cursor_visual block

      fish_default_key_bindings -M insert
      fish_vi_key_bindings --no-erase insert
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
            sponge
            fzf-fish
            forgit
          ]
        );
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.nix-index.enable = true;

  programs.eza = {
    enable = true;
    icons = "auto";
    extraOptions = [
      "--color=auto"
    ];
  };

  programs.git = {
    enable = true;
    userName = "Komo";
    userEmail = "afiqquraisyzulkarnain@gmail.com";
  };

  programs.gh = {
    enable = true;
    extensions = with pkgs; [
      gh-poi
      gh-eco
      gh-screensaver
      gh-s
      gh-f
      gh-notify
      gh-markdown-preview
    ];
    settings.aliases = {
      rcl = "repo clone";
      rfk = "repo fork";
      rmv = "repo rename";
      rdl = "repo delete --yes";
    };
  };

  programs.wofi = {
    enable = true;
  };

  services.dunst = {
    enable = true;
    settings = loadConfig' "dunst" { };
  };

  programs.eww = {
    enable = true;
    configDir = ./configs/eww;
  };

  services.hypridle = {
    enable = true;
    settings = loadConfig "hypr/idle" { };
  };

  services.hyprpaper = {
    enable = true;
    settings = loadConfig "hypr/paper" { };
  };

  programs.hyprlock = {
    enable = true;
    settings = loadConfig "hypr/lock" { };
  };

  wayland.windowManager.hyprland = {
    enable = true;
    settings = loadConfig "hypr/wm" { };
    xwayland.enable = true;
  };

  programs.yazi = {
    enable = true;
    settings = loadConfig "yazi" { };
    keymap = loadConfig "yazi/keymaps" { };
    plugins = with pkgs.yaziPlugins; {
      inherit
        bypass
        projects
        ouch
        diff
        ;
    };
  };

  programs.fzf = {
    enable = true;
    defaultCommand = ''
      fd --type f --strip-cwd-prefix
    '';
    defaultOptions = [
      "--style full"
    ];
  };

  programs.iamb = {
    enable = true;
    settings = loadConfig' "iamb" { };
  };

  services.wluma = {
    enable = true;
    settings = loadConfig "wluma" { };
    systemd = {
      enable = true;
      target = "hyprland-session.target";
    };
  };

  services.arrpc = {
    enable = true;
    systemdTarget = "hyprland-session.target";
  };

  services.hyprpolkitagent = {
    enable = true;
  };

  programs.jujutsu = {
    enable = true;
    settings = loadConfig' "jujutsu" { };
  };

  programs.vesktop = {
    enable = true;
    settings = loadConfig' "vesktop" { };
    vencord = {
      settings = loadConfig' "vesktop/vencord" { };
    };
  };

  caches.cachix = [
    "nix-community"
    "mbekkomo"
  ];

  gtk = {
    enable = true;
  };
}
