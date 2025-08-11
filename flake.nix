{
  description = "My Nix config :3";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-flatpak.url = "github:gmodena/nix-flatpak/latest";
    nix-search-cli = {
      url = "github:peterldowns/nix-search-cli";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixGL = {
      url = "github:nix-community/nixGL";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    declarative-cachix.url = "github:jonascarpay/declarative-cachix";
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    catppuccin.url = "github:catppuccin/nix";
    nix-std.url = "github:chessai/nix-std";
    matui = {
      url = "github:pkulak/matui";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    chaotic = {
      url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-cwc = {
      url = "github:0komo/nix-cwc";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zen-browser = {
      url = "github:pfaj/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  nixConfig = {
    extra-substituters = [
      "https://nix-community.cachix.org"
      "https://winapps.cachix.org"
      "https://chaotic-nyx.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "winapps.cachix.org-1:HI82jWrXZsQRar/PChgIx1unmuEsiQMQq+zt05CD36g="
      "chaotic-nyx.cachix.org-1:HfnXSw4pj95iI/n17rIDy40agHj12WfF+Gqk6SonIT8="
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
      matui,
      chaotic,
      nix-cwc,
      zen-browser,
      ...
    }:
    let
      system =
        let
          x = (builtins.getEnv "NIXPKGS_SYSTEM");
        in
        if x == "" then "x86_64-linux" else x;
      pkgs = (
        ((nixpkgs.legacyPackages.${system}.extend nur.overlays.default).extend nix-cwc.overlays.default)
        .extend
          (
            final: prev: {
              bun = prev.bun.overrideAttrs rec {
                passthru.sources."x86_64-linux" = pkgs.fetchurl {
                  url = "https://github.com/oven-sh/bun/releases/download/bun-v${prev.bun.version}/bun-linux-x64-baseline.zip";
                  hash = "sha256-x1BMIW2HKRBdF4E4VmXjrCxj3r27XeTv3BLi1sSmy0o="; # update this
                };
                src = passthru.sources."x86_64-linux";
              };
              nix-search = nix-search-cli.outputs.packages.${system}.nix-search;
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
      );
    in
    {
      homeConfigurations.komo = home-manager.lib.homeManagerConfiguration {
        pkgs = pkgs;
        modules = [
          declarative-cachix.homeManagerModules.declarative-cachix
          nix-index-database.hmModules.nix-index
          catppuccin.homeModules.catppuccin
          nix-flatpak.homeManagerModules.nix-flatpak
          chaotic.homeManagerModules.default
          nix-cwc.homeManagerModules.default
          ./dotfiles/home.nix
        ];
        extraSpecialArgs.std = nix-std.lib;
      };

      formatter.${system} = pkgs.nixfmt-tree;
    }
    // (
      let
        mkConfig =
          x:
          nixpkgs.lib.nixosSystem {
            inherit system;
            inherit pkgs;
            modules = [
              nix-flatpak.nixosModules.nix-flatpak
              chaotic.nixosModules.default
              nix-cwc.nixosModules.default
              ./nixos/hardwares/${x}/configuration.nix
              ./nixos/hardwares/${x}/hardware-configuration.nix
              ./nixos/configuration.nix
            ];
          };
        systems = [
          "Aspire-TC-605"
          "HP-240-G5-Notebook-PC"
        ];
      in
      {
        nixosConfigurations = builtins.listToAttrs (
          map (x: {
            name = x;
            value = mkConfig x;
          }) systems
        );
      }
    );
}
