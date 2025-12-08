{
  pkgs,
  lib,
  config,
  ...
}:
{
  system.stateVersion = "24.05";

  networking.hostName = "gudboye";

  environment.systemPackages = with pkgs; [
    git
    refind
    gptfdisk
    efibootmgr
    udisks
    doas-sudo-shim
    zen-browser

    waterfox

    # greeter
    regreet

    # useless things
    openutau
  ];

  nix = {
    package = pkgs.lixPackageSets.latest.lix;
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      trusted-users = [ "komo" ];
    };
  };

  services.greetd = {
    enable = true;
    settings.default_session = {
      command = "env GTK_USE_PORTAL=0 GDK_DEBUG=no-portals LIBSEAT_BACKEND=logind ${lib.getExe pkgs.cage} -s -mlast -- ${lib.getExe pkgs.regreet}";
    };
  };

  programs.regreet = {
    enable = true;
    theme = {
      name = "Graphite-Dark";
      package = pkgs.graphite-gtk-theme.override {
        themeVariants = [ "default" ];
        tweaks = [
          "rimless"
          "darker"
        ];
      };
    };
    cursorTheme = {
      name = "catppuccin-mocha-yellow-cursors";
      package = pkgs.catppuccin-cursors.mochaYellow;
    };
    iconTheme = {
    };
    settings = {
      background = {
        path = ../resources/wallpapers/regreet-wallpaper.png;
        fit = "Contain";
      };
    };
  };

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  security.pam.services.hyprlock = { };

  boot = {
    loader = {
      grub.enable = lib.mkForce false;
      systemd-boot.enable = lib.mkForce true;
      efi.canTouchEfiVariables = true;
    };

    # comment this if something's fucked up
    kernelPackages = pkgs.linuxPackages_zen;
    kernelParams = [
      "vt.default_red=30,243,166,249,137,245,148,186,88,243,166,249,137,245,148,166"
      "vt.default_grn=30,139,227,226,180,194,226,194,91,139,227,226,180,194,226,173"
      "vt.default_blu=46,168,161,175,250,231,213,222,112,168,161,175,250,231,213,200"
    ];

    kernel.sysctl = {
      "vm.swappiness" = 100;
      "kernel.sysrq" = 1;
    };
  };

  programs.nix-ld = {
    enable = true;
  };

  networking.nameservers = [
    "1.1.1.1"
    "1.0.0.1"
  ];

  services.resolved = {
    enable = true;
    fallbackDns = [
      "127.0.0.1"
      "::1"
    ];
    dnsovertls = "true";
  };

  networking.networkmanager.enable = true;
  networking.networkmanager = {
    wifi.backend = "iwd";
  };

  networking.networkmanager.settings = {
    logging = {
      level = "TRACE";
      domains = "ALL";
    };
  };

  programs.nm-applet.enable = true;

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  services.blueman = {
    enable = true;
  };

  time.timeZone = "Asia/Makassar";

  i18n.defaultLocale = "en_US.UTF-8";

  services.xserver = {
    enable = true;
    xkb = {
      layout = "us";
      variant = "";
    };
  };

  services.kmscon.enable = true;
  services.kmscon = {
    autologinUser = "komo";
    useXkbConfig = true;
    hwRender = true;
    extraConfig = ''
      font-size=11
      login=/usr/bin/env fish -l
      mouse
      palette=soft-black
    '';
    fonts = [
      {
        name = "GohuFont 14 Nerd Font";
        package = pkgs.nerd-fonts.gohufont;
      }
    ];
  };

  services.printing = {
    enable = true;
    drivers = with pkgs; [
      gutenprint
      gutenprintBin
      (epson-201401w.override {
        stdenv = clangStdenv;
      })
    ];
  };
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  services.pulseaudio = {
    enable = false;
  };

  security.rtkit = {
    enable = true;
  };

  services.pipewire = {
    enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };
    pulse.enable = true;
  };

  services.openssh = {
    enable = true;
  };

  services.udisks2 = {
    enable = true;
  };

  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
  };

  users.users.komo = {
    isNormalUser = true;
    description = "Komo";
    extraGroups = [
      "networkmanager"
      "wheel"
      "video"
      "i2c"
    ];
  };

  fonts.fontDir.enable = true;
  fonts.packages = with pkgs; [
    nerd-fonts.gohufont
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
  ];

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  programs.adb = {
    enable = true;
  };

  programs.appimage = {
    enable = true;
    binfmt = true;
  };

  programs.nh = {
    enable = true;
    clean = {
      enable = true;
      extraArgs = "--keep 2 --keep-since 3d";
    };
  };

  services.kanata = {
    enable = true;
    keyboards = {
      home-row = {
        extraDefCfg = ''
          process-unmapped-keys yes
        '';
        config = builtins.readFile ./configs/kanata/asdf.lisp;
      };
    };
  };

  services.gnome.gnome-keyring = {
    enable = true;
  };

  services.flatpak.enable = true;

  services.cloudflare-warp.enable = true;

  security.sudo.enable = lib.mkForce false;
  security.doas = {
    enable = true;
    extraRules = [
      {
        users = [ "komo" ];
        persist = true;
      }
    ];
  };

  hardware.i2c.enable = true;

  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="backlight", RUN+="${pkgs.coreutils}/bin/chgrp video /sys/class/backlight/%k/brightness"
    ACTION=="add", SUBSYSTEM=="backlight", RUN+="${pkgs.coreutils}/bin/chmod g+w /sys/class/backlight/%k/brightness"
    ACTION=="add", SUBSYSTEM=="leds", RUN+="${pkgs.coreutils}/bin/chgrp video /sys/class/leds/%k/brightness"
    ACTION=="add", SUBSYSTEM=="leds", RUN+="${pkgs.coreutils}/bin/chmod g+w /sys/class/leds/%k/brightness"
  '';

  services.desktopManager.cosmic.enable = true;
  services.displayManager.cosmic-greeter.enable = false;
}
