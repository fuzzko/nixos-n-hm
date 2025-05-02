{
  description = "My Nix config :3";

  inputs = {
    nixpkgs.url = "github:numtide/nixpkgs-unfree/nixos-unstable";
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs/nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs/nixpkgs";
    };
    nix-flatpak.url = "github:gmodena/nix-flatpak/latest";
    nix-search-cli = {
      url = "github:peterldowns/nix-search-cli";
      inputs.nixpkgs.follows = "nixpkgs/nixpkgs";
    };
    nixGL = {
      url = "github:nix-community/nixGL";
      inputs.nixpkgs.follows = "nixpkgs/nixpkgs";
    };
    declarative-cachix.url = "github:jonascarpay/declarative-cachix";
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs/nixpkgs";
    };
    catppuccin.url = "github:catppuccin/nix";
    nix-std.url = "github:chessai/nix-std";
    nix-ld = {
      url = "github:nix-community/nix-ld";
      inputs.nixpkgs.follows = "nixpkgs/nixpkgs";
    };
    winapps = {
      url = "github:winapps-org/winapps";
      inputs.nixpkgs.follows = "nixpkgs/nixpkgs";
    };
    yazi-plugins-overlay = {
      url = "github:mbekkomo/yazi-plugins-overlay";
      inputs.nixpkgs.follows = "nixpkgs/nixpkgs";
    };
    lucem = {
      url = "github:mbekkomo/lucem/add-flake-nix";
      inputs.nixpkgs.follows = "nixpkgs/nixpkgs";
    };
    matui = {
      url = "github:pkulak/matui";
      inputs.nixpkgs.follows = "nixpkgs/nixpkgs";
    };
    chaotic = {
      url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
      inputs.nixpkgs.follows = "nixpkgs/nixpkgs";
    };
  };

  nixConfig = {
    extra-subtituters = [
      "https://nix-community.cachix.org"
      "https://winapps.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "winapps.cachix.org-1:HI82jWrXZsQRar/PChgIx1unmuEsiQMQq+zt05CD36g="
    ];
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      nix-search-cli,
      nixGL,
      declarative-cachix,
      nix-index-database,
      catppuccin,
      nix-std,
      nur,
      nix-flatpak,
      nix-ld,
      winapps,
      yazi-plugins-overlay,
      lucem,
      matui,
      chaotic,
      ...
    }:
    let
      system =
        let
          x = (builtins.getEnv "NIXPKGS_SYSTEM");
        in
        if x == "" then "x86_64-linux" else x;
      pkgs =
        ((nixpkgs.legacyPackages.${system}.extend nur.overlays.default).extend
          yazi-plugins-overlay.overlays.default
        ).extend
          (
            final: prev: {
              bun = prev.bun.overrideAttrs rec {
                passthru.sources."x86_64-linux" = pkgs.fetchurl {
                  url = "https://github.com/oven-sh/bun/releases/download/bun-v${prev.bun.version}/bun-linux-x64-baseline.zip";
                  hash = "sha256-S2L1mQSO8yCnYbrL7rcfh4T143O5dqnVOz7ngR8ZsAQ="; # update this
                };
                src = passthru.sources."x86_64-linux";
              };
              nix-search = nix-search-cli.outputs.packages.${system}.nix-search;
              nixGLPackages = nixGL.outputs.packages.${system};
              winapps = winapps.packages.${system}.winapps;
              winapps-launcher = winapps.packages.${system}.winapps-launcher;
              lucem = lucem.packages.${system}.lucem;
              matui = matui.packages.${system}.matui;
            }
          );
    in
    {
      homeConfigurations.komo = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          declarative-cachix.homeManagerModules.declarative-cachix
          nix-index-database.hmModules.nix-index
          catppuccin.homeModules.catppuccin
          nix-flatpak.homeManagerModules.nix-flatpak
          chaotic.homeManagerModules.default
          ./dotfiles/home.nix
        ];
        extraSpecialArgs.std = nix-std.lib;
      };

      nixosConfigurations.HP-240-G5-Notebook-PC = nixpkgs.lib.nixosSystem {
        inherit system;
        inherit pkgs;
        modules = [
          nix-flatpak.nixosModules.nix-flatpak
          nix-ld.nixosModules.nix-ld
          chaotic.nixosModules.default
          ./modules/refind/refind.nix
          ./nixos/hardwares/HP-240-G5-Notebook-PC/configuration.nix
          ./nixos/hardwares/HP-240-G5-Notebook-PC/hardware-configuration.nix
          ./nixos/configuration.nix
        ];
      };

      nixosConfigurations.Aspire-TC-605 = nixpkgs.lib.nixosSystem {
        inherit system;
        inherit pkgs;
        modules = [
          nix-flatpak.nixosModules.nix-flatpak
          nix-ld.nixosModules.nix-ld
          chaotic.nixosModules.default
          ./modules/refind/refind.nix
          ./nixos/hardwares/Aspire-TC-605/configuration.nix
          ./nixos/hardwares/Aspire-TC-605/hardware-configuration.nix
          ./nixos/configuration.nix
        ];
      };

      formatter.${system} = pkgs.nixfmt-tree;
    };
}
