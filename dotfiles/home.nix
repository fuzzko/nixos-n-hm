{
  config,
  pkgs,
  lib,
  ...
}@inputs:
let
  wrapGL = config.lib.nixGL.wrap;

  inherit (config.lib) komo;

  loadConfig = x: y: import ./configs/${x}.nix (inputs // { root = ./.; } // y);
  loadConfig' = x: y: import ./configs/${x} (inputs // { root = ./.; } // y);
in
{
  # A simple business logic to import all configs in ./options, you should check that dir too
  import = (komo.filterFilesInDir (x: (builtins.baseNameOf x) == "default.nix") ./options) ++ [ ];

  programs.home-manager.enable = true;
  home = {
    username = "komo";
    homeDirectory = /home/${config.home.username};
  };
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
      ouch

      # Something that would ease me off
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
      nemo
      nemo-preview
      nemo-fileroller
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

      # For CwC
      app2unit

      # For recording
      kooha
      scrcpy
      mumble

      # i don't fucking know why i installed these shits but i installed them anyway
      youtube-music
      qview
      openutau
      nchat
      kdePackages.kdenlive
      audacity
      igrep
      packet
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
    "XDG_PICTURES_DIR" = "${config.home.homeDirectory}/Pictures";
    "BROWSER" = "zen";
    "IGREP_CUSTOM_EDITOR" = "hx {file_name}:{line_number}";
    "PAGER" = "moar";
    "GIT_PAGER" = PAGER;
    "SYSTEMD_PAGERSECURE" = "true";
    "APP2UNIT_SLICES" = "a=app-graphical.slice b=background-graphical.slice s=session-graphical.slice";
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
      "io.itch.itch"
      "org.vinegarhq.Sober"
      "com.usebottles.bottles"
    ];
    update.auto = {
      enable = true;
    };
    uninstallUnmanaged = true;
  };

  catppuccin = {
    flavor = "mocha";
    accent = "sky";
    enable = true;

    cursors.enable = true;
    fzf.enable = true;
    helix.enable = true;
    fish.enable = true;
    hyprlock.useDefaultConfig = false;
  };

  nixGL = {
    packages = pkgs.nixGLPackages;
    defaultWrapper = "mesa";
    installScripts = [ "mesa" ];
  };

  xdg.portal.enable = lib.mkForce true;
  xdg.portal = {
    xdgOpenUsePortal = true;
    configPackages = [
      pkgs.hyprland
    ];
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


  fonts.fontconfig.enable = true;
  fonts.fontconfig.defaultFonts.emoji = [ "Noto Color Emoji" ];

  programs.starship = {
    enable = true;
    settings = loadConfig "starship" { };
  };

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
    package = null;
    settings = loadConfig "hypr/wm" { };
    xwayland.enable = true;
  };

  wayland.windowManager.cwc = {
    enable = true;
    package = null;
    systemd.enable = false;
    extraConfig = ''
      do
        local fnl = require("fennel").install()
        fnl.path = fnl.path .. [[;${config.xdg.configHome}/cwc/?.fnl]]
        fnl.path = fnl.path .. [[;${config.xdg.configHome}/cwc/?/init.fnl]]
        local macro_path = ""
        macro_path = macro_path .. ";" .. fnl.path
        macro_path = macro_path .. [[;${config.xdg.configHome}/cwc/?.fnlm]]
        macro_path = macro_path .. [[;${config.xdg.configHome}/cwc/?/init.fnlm]]
        macro_path = macro_path .. [[;${config.xdg.configHome}/cwc/?/init-macros.fnl]]
        fnl["macro-path"] = fnl["macro-path"] .. macro_path
        fnl.dofile([[${config.xdg.configHome}/cwc/rc.fnl]])
      end
    '';
  };

  xdg.configFile."cwc" = {
    source = ./configs/cwc;
    recursive = true;
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

  programs.atuin = {
    enable = true;
    settings = loadConfig' "atuin" { };
  };

  caches.cachix = [
    "nix-community"
    "mbekkomo"
  ];

  gtk = {
    enable = true;
  };
}
