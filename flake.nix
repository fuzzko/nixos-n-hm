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
    nix-ld = {
      url = "github:nix-community/nix-ld";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    helix = {
      url = "github:helix-editor/helix/44bddf51b76eab8b4096448e52a33964a52f7d2e";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    winapps = {
      url = "github:winapps-org/winapps";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    yazi-plugins-overlay = {
      url = "github:mbekkomo/yazi-plugins-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lucem = {
      url = "github:mbekkomo/lucem/add-flake-nix";
      inputs.nixpkgs.follows = "nixpkgs";
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
      helix,
      winapps,
      yazi-plugins-overlay,
      lucem,
      ...
    }:
    let
      system =
        let
          x = (builtins.getEnv "NIXPKGS_SYSTEM");
        in
        if x == "" then "x86_64-linux" else x;
      pkgs = import nixpkgs {
        inherit system;
        config = {
          allowUnfree = true;
        };
        overlays = [
          nur.overlays.default
          (final: prev: {
            bun = prev.bun.overrideAttrs rec {
              passthru.sources."x86_64-linux" = pkgs.fetchurl {
                url = "https://github.com/oven-sh/bun/releases/download/bun-v${prev.bun.version}/bun-linux-x64-baseline.zip";
                hash = "sha256-JdFwwxBgfo894v+7cXf1iB11sPYOHpwQqZYOpx126X0="; # update this
              };
              src = passthru.sources."x86_64-linux";
            };
            nix-search = nix-search-cli.outputs.packages.${system}.nix-search;
            nixGLPackages = nixGL.outputs.packages.${system};
            helixUnstable = helix.outputs.packages.${system}.helix.overrideAttrs {
              NIX_BUILD_CORES = "8";
            };
            winapps = winapps.packages.${system}.winapps;
            winapps-launcher = winapps.packages.${system}.winapps-launcher;
            lucem = lucem.packages.${system}.lucem;
          })
          yazi-plugins-overlay.overlays.default
        ];
      };
    in
    {
      homeConfigurations.komo = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          declarative-cachix.homeManagerModules.declarative-cachix
          nix-index-database.hmModules.nix-index
          catppuccin.homeManagerModules.catppuccin
          nix-flatpak.homeManagerModules.nix-flatpak
          ./home-manager/home.nix
        ];
        extraSpecialArgs.std = nix-std.lib;
      };

      nixosConfigurations.komo = nixpkgs.lib.nixosSystem {
        inherit system;
        inherit pkgs;
        modules = [
          nix-flatpak.nixosModules.nix-flatpak
          nix-ld.nixosModules.nix-ld
          ./modules/refind/refind.nix
          ./Aspire-TC-605/configuration.nix
        ];
      };

      formatter.${system} = pkgs.nixfmt-tree;
    };
}
