{
  config,
  lib,
  pkgs,
  ...
}:
{
  programs.home-manager.enable = true;
  home.stateVersion = "24.05";

  home = {
    username = "komo";
    homeDirectory = /home/${config.home.username};
  };

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
      moor
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
      dragon-drop
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
    ]
  );

  home.sessionVariables = {
    "BROWSER" = "zen";
    "IGREP_CUSTOM_EDITOR" = "hx {file_name}:{line_number}";
    "SYSTEMD_PAGERSECURE" = "true";
  };

  home.keyboard.options = [
    "caps:none"
    "shift:both_capslock_cancel"
  ];

  home.pointerCursor.enable = true;
  home.pointerCursor.package = pkgs.catppuccin-cursors;
  home.pointerCursor.name = "Catppuccin Mocha Blue";
  home.pointerCursor.size = 15;
  home.pointerCursor = {
    hyprcursor.enable = true;
    x11.enable = true;
  };
}
