{
  pkgs,
  lib,
  ...
}:
let
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
  departure-nf-mono = pkgs.departure-mono.overrideAttrs {
    pname = "departure-nerd-font";
    nativeBuildInputs = [ pkgs.nerd-font-patcher ];
    installPhase = ''
      runHook preInstall

      nerd-font-patcher --mono -c *.otf -out $out/share/fonts/otf
      nerd-font-patcher --mono -c *.woff -out $out/share/woff || true
      nerd-font-patcher --mono -c *.woff2 -out $out/share/woff2 || true

      runHook postInstall
    '';
  };
in
{
  specialisation =
    let
      mkSpec = name: {
        ${name}.configuration.imports = [
          ./hardwares/${name}/configuration.nix
          ./hardwares/${name}/hardware-configuration.nix
        ];
      };
    in
    (mkSpec "HP-240-G5-Notebook-PC") // (mkSpec "Aspire-TC-605");

  imports = [
    ./hardwares/HP-240-G5-Notebook-PC/hardware-configuration.nix
  ];

  system.stateVersion = "24.05";

  networking.hostName = "gudboye";

  environment.systemPackages = with pkgs; [
    git
    refind
    gptfdisk
    efibootmgr
    udisks
    connman-gtk

    # greeter
    greetd.regreet

    # useless things
    openutau
  ];

  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      trusted-users = [ "komo" ];
    };
  };

  environment.etc = {
    "greetd/hyprland.conf".text = ''
       exec-once = regreet; hyprctl dispatch exit
       misc {
         disable_hyprland_logo = true
         disable_splash_rendering = true
         disable_hyprland_qtutils_check = true
      }
       env = GTK_USE_PORTAL,0
       env = GDK_DEBUG,no-portals
    '';
  };

  services.greetd = {
    enable = true;
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
      systemd-boot.enable = lib.mkDefault false;
      refind.enable = true;
      refind.extraConfig = ''
        enable_touch true
        include themes/rEFInd-minimal-dark/theme.conf
      '';
      efi.canTouchEfiVariables = true;
    };

    # comment this if something's fucked up
    kernelPackages = pkgs.linuxPackages_zen;
    # kernelParams = [
    #   "vt.default_red=30,243,166,249,137,245,148,186,88,243,166,249,137,245,148,166 vt.default_grn=30,139,227,226,180,194,226,194,91,139,227,226,180,194,226,173 vt.default_blu=46,168,161,175,250,231,213,222,112,168,161,175,250,231,213,200"
    # ];
  };

  programs.nix-ld = {
    dev.enable = true;
  };

  networking.wireless.iwd = {
    enable = true;
    settings = {
      Settings = {
        AutoConnect = true;
      };
      General = {
        EnableNetworkConfigure = true;
      };
    };
  };
  services.connman = {
    enable = true;
    package = pkgs.connmanFull;
    wifi.backend = "iwd";
  };
  networking.nameservers = [
    "127.0.0.1"
    "::1"
  ];

  services.dnscrypt-proxy2 = {
    enable = true;
    settings = {
      ipv6_servers = true;
      require_dnssec = true;
      sources.public-resolvers = {
        urls = [
          "https://raw.githubusercontent.com/DNSCrypt/dnscrypt-resolvers/master/v3/public-resolvers.md"
          "https://download.dnscrypt.info/resolvers-list/v3/public-resolvers.md"
        ];
        cache_file = "/var/lib/dnscrypt-proxy2/public-resolvers.md";
        minisign_key = "RWQf6LRCGA9i53mlYecO4IzT51TGPpvWucNSCh1CBM0QTaLn73Y7GFO3";
      };
      server_names = [
        "mullvad-base-doh"
        "cloudflare"
        "nextdns"
        "nextdns-ipv6"
      ];
    };
  };
  systemd.services.dnscrypt-proxy2.serviceConfig = {
    StateDirectory = "dnscrypt-proxy";
  };

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

  services.kmscon = {
    enable = true;
    hwRender = true;
    fonts = [
      {
        name = "DepartureMono Nerd Font Mono";
        package = departure-nf-mono;
      }
      {
        name = "Noto fonts";
        package = pkgs.noto-fonts;
      }
      {
        name = "Noto fonts (Emoji)";
        package = pkgs.noto-fonts-emoji;
      }
    ];
  };

  services.printing = {
    enable = true;
    drivers = with pkgs; [
      gutenprint
      gutenprintBin
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

  services.resolved = {
    enable = false;
  };

  services.flatpak = {
    enable = true;
    packages = [
      "io.itch.itch"
    ];
  };

  services.udisks2 = {
    enable = true;
  };

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-hyprland
      xdg-desktop-portal-gtk
    ];
  };

  users.users.komo = {
    isNormalUser = true;
    description = "Komo";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
  };

  fonts.fontDir.enable = true;
  fonts.packages = with pkgs; [
    departure-nf
    departure-nf-mono
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
}
