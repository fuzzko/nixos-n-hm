{
  description = "My Nix config :3";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nur.url = "github:nix-community/NUR";
    home-manager.url = "github:nix-community/home-manager/master";
    nix-flatpak.url = "github:gmodena/nix-flatpak/latest";
    nix-search-cli.url = "github:peterldowns/nix-search-cli";
    nixGL.url = "github:nix-community/nixGL";
    declarative-cachix.url = "github:jonascarpay/declarative-cachix";
    nix-index-database.url = "github:nix-community/nix-index-database";
    catppuccin.url = "github:catppuccin/nix";
    nix-std.url = "github:chessai/nix-std";
    matui.url = "github:pkulak/matui";
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    nix-cwc.url = "github:0komo/nix-cwc";
    zen-browser.url = "github:pfaj/zen-browser-flake";
    niri-flake.url = "github:sodiboo/niri-flake";
    xwayland-satellite.url = "github:Supreeeme/xwayland-satellite";
    kidex.url = "github:Kirottu/kidex";
    wired.url = "github:Toqozz/wired-notify";
    ls_colors.url = "github:trapd00r/LS_COLORS";
    eza-themes.url = "github:eza-community/eza-themes";
    flakelight.url = "github:nix-community/flakelight";

    nur.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nix-search-cli.inputs.nixpkgs.follows = "nixpkgs";
    nixGL.inputs.nixpkgs.follows = "nixpkgs";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";
    matui.inputs.nixpkgs.follows = "nixpkgs";
    chaotic.inputs.nixpkgs.follows = "nixpkgs";
    nix-cwc.inputs.nixpkgs.follows = "nixpkgs";
    zen-browser.inputs.nixpkgs.follows = "nixpkgs";
    niri-flake.inputs.nixpkgs.follows = "nixpkgs";
    xwayland-satellite.inputs.nixpkgs.follows = "nixpkgs";
    kidex.inputs = {
      nixpkgs.follows = "nixpkgs";
      home-manager.follows = "home-manager";
    };
    wired.inputs.nixpkgs.follows = "nixpkgs";
    ls_colors.flake = false;
    eza-themes.flake = false;
    flakelight.inputs.nixpkgs.follows = "nixpkgs";
  };

  nixConfig = {
    extra-substituters = [
      "https://nix-community.cachix.org"
      "https://winapps.cachix.org"
      "https://chaotic-nyx.cachix.org"
      "https://niri.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "winapps.cachix.org-1:HI82jWrXZsQRar/PChgIx1unmuEsiQMQq+zt05CD36g="
      "chaotic-nyx.cachix.org-1:HfnXSw4pj95iI/n17rIDy40agHj12WfF+Gqk6SonIT8="
      "niri.cachix.org-1:Wv0OmO7PsuocRKzfDoJ3mulSl7Z6oezYhGhR+3W2964="
    ];
  };

  outputs =
    {
      home-manager,
      nix-search-cli,
      nixGL,
      declarative-cachix,
      nix-index-database,
      catppuccin,
      nix-std,
      nur,
      nix-flatpak,
      matui,
      chaotic,
      nix-cwc,
      zen-browser,
      niri-flake,
      xwayland-satellite,
      kidex,
      wired,
      flakelight,
      ...
    }@inputs:
    flakelight ./. (
      { lib, config, ... }:
      {
        inherit inputs;

        nixpkgs.config = {
          allowUnfree = true;
        };

        withOverlays = [
          nur.overlays.default
          nix-cwc.overlays.default
          niri-flake.overlays.niri
          (
            final: prev:
            let
              inherit (prev) system;
            in
            {
              inherit (nix-search-cli.outputs.packages.${system}) nix-search;
              xwayland-satellite-unstable = xwayland-satellite.outputs.packages.${system}.xwayland-satellite;
              nixGLPackages = nixGL.outputs.packages.${system};
              matui = matui.packages.${system}.matui;
              zen-browser =
                let
                  packs = zen-browser.outputs.packages.${system};
                  passthru = builtins.removeAttrs packs [ "default" ];
                in
                packs.default.overrideAttrs {
                  inherit passthru;
                };
            }
          )
        ];

        homeConfigurations.komo =
          let
            komoLib = import ./lib lib;
          in
          {
            system = "x86_64-linux";
            modules = [
              declarative-cachix.homeManagerModules.declarative-cachix
              nix-index-database.homeModules.nix-index
              catppuccin.homeModules.catppuccin
              nix-flatpak.homeManagerModules.nix-flatpak
              chaotic.homeManagerModules.default
              nix-cwc.homeManagerModules.default
              niri-flake.homeModules.niri
              kidex.homeModules.kidex
              wired.homeManagerModules.default
              ./modules/hm/moor
              ./home/options/lib/komo
            ]
            ++ (komoLib.filterFilesInDir (x: (builtins.baseNameOf x) == "default.nix") ./home/options);
          };

        nixosConfigurations =
          let
            mkSystem = x: {
              modules = [
                config.propagationModule
                nix-flatpak.nixosModules.nix-flatpak
                chaotic.nixosModules.default
                nix-cwc.nixosModules.default
                niri-flake.nixosModules.niri
                ./nixos/hardwares/${x}/configuration.nix
                ./nixos/hardwares/${x}/hardware-configuration.nix
                ./nixos/configuration.nix
              ];
            };
          in
          {
            Aspire-TC-605 = mkSystem "Aspire-TC-605";
            HP-240-G5-Notebook-PC = mkSystem "HP-240-G5-Notebook-PC";
          };

        formatters =
          pkgs: with pkgs; {
            "*.nix" = lib.getExe nixfmt;
            "*.sh" = lib.getExe shfmt;

          };
      }
    );
}
