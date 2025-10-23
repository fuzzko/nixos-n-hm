{ ... }: {
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
    {
      ".config/zls.json".text = builtins.toJSON (loadConfig "zls" { });
    };

  home.sessionVariables = rec {
    "XDG_PICTURES_DIR" = "${config.home.homeDirectory}/Pictures";
    "BROWSER" = "zen";
    "IGREP_CUSTOM_EDITOR" = "hx {file_name}:{line_number}";
    "PAGER" = "moar";
    "GIT_PAGER" = PAGER;
    "SYSTEMD_PAGERSECURE" = "true";
  };
}
