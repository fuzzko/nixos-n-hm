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
  import = (komo.filterFilesInDir (x: (builtins.baseNameOf x) == "default.nix") ./options) ++ [
    ../modules/hm/moor
  ];

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
  };

  home.pointerCursor = {
    enable = true;
    size = 15;
    hyprcursor.enable = true;
    x11.enable = true;
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

  programs.starship = {
    enable = true;
    settings = loadConfig "starship" { };
  };

  programs.nix-index.enable = true;

  programs.git = {
    enable = true;
    userName = "Komo";
    userEmail = "afiqquraisyzulkarnain@gmail.com";
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

  services.arrpc = {
    enable = true;
  };

  caches.cachix = [
    "nix-community"
    "mbekkomo"
  ];

  gtk = {
    enable = true;
  };
}
