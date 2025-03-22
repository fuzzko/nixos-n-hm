{
  config,
  pkgs,
  std,
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
  toString =
    x:
    if x == true then
      "true"
    else if x == false then
      "false"
    else
      builtins.toString x;
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
        ubuntu
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

      # For hyprland
      nautilus
      nautilus-open-any-terminal
      hyprpolkitagent
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

      # For recording
      kooha
      scrcpy
      mumble

      # i don't fucking know why i installed these shits but i installed them anyway
      youtube-music
      openutau
      nchat
      (with nur.repos.mbekkomo; [
        (wrapGL sklauncher)
      ])
    ]
  );

  home.file =
    # External Config
    {
      ".config/zls.json".text = builtins.toJSON (loadConfig "zls" { });
      ".config/wluma/config.toml".text = std.serde.toTOML (loadConfig "wluma" { });
      ".config/winapps/winapps.conf".text = builtins.replaceStrings [ " = \"" ] [ "=\"" ] (
        std.serde.toTOML (builtins.mapAttrs (name: value: toString value) (loadConfig "winapps" { }))
      );
      ".config/walker/config.json".text = builtins.toJSON (loadConfig "walker" { });
      # Misc. files
      ".config/winapps/compose.yaml".source = ./configs/winapps/compose.yaml;
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
      "io.github.milkshiift.GoofCord"
      "im.nheko.Nheko"
      "org.kde.kwalletmanager5"
      "com.interversehq.qView"
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
  };

  nix = {
    package = pkgs.nix;
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      allowed-users = [ username ];
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

  systemd.user.services.arRPC = {
    Unit.PartOf = [ "graphical-session.target" ];
    Service = {
      ExecStart = "${pkgs.bun}/bin/bun ${pkgs.arrpc}/lib/node_modules/arrpc/src/index.js";
      Restart = "always";
    };
    Install.WantedBy = [ "hyprland-session.target" ];
  };

  fonts.fontconfig.enable = true;
  fonts.fontconfig.defaultFonts.emoji = [ "Noto Color Emoji" ];

  programs.helix = {
    enable = true;
    package = pkgs.helixUnstable;
    defaultEditor = true;
    extraPackages = lib.flatten (
      with pkgs;
      [
        nushell

        nixfmt-tree
        shellcheck

        (with nur.repos.mbekkomo; [
          emmylua-codestyle
          emmylua_ls
        ])

        nil
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
      "ui.cursorline.primary" = { };
      "ui.linenr".fg = "overlay1";
    };
  };

  programs.alacritty = {
    enable = true;
    package = wrapGL pkgs.alacritty;
    settings = loadConfig "alacritty" { };
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

      bind alt-y 'yy'
      bind alt-shift-y 'yazi'
    '';
    plugins = (
      builtins.map
        (x: {
          name = x.name;
          src = x.src;
        })
        (
          with pkgs.fishPlugins;
          [
            fifc
            done
            colored-man-pages
            autopair
            git-abbr
          ]
        )
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
    diff-so-fancy.enable = true;
    userName = "Komo";
    userEmail = "afiqquraisyzulkarnain@gmail.com";
    extraConfig = loadConfig "git" { };
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
        first-non-directory
        ;
      wl-clipboard = wl-clipboard.overrideAttrs {
        nativeBuildInputs = with pkgs; [ sd ];
        patchPhase = ''
          sd -F 'tab.selected' 'cx.yanked' init.lua
        '';
      };
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

  caches.cachix = [
    "nix-community"
    "mbekkomo"
  ];

  gtk = {
    enable = true;
  };
}
