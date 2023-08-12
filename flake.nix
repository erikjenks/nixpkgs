{
  description = "You new nix config";

  nixConfig = {
    extra-trusted-public-keys = "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw=";
    extra-substituters = "https://devenv.cachix.org";
  };

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    # Home manager
    home-manager.url = "github:nix-community/home-manager/release-23.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # Nix Darwin
    darwin.url = "github:lnl7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";

    # Other Tools
    flake-parts.url = "github:hercules-ci/flake-parts";
    devenv.url = "github:cachix/devenv/latest";

    # Adam's Flake
    adamgoose.url = "github:adamgoose/nixpkgs/23.05";
    adamgoose.inputs.nixpkgs.follows = "nixpkgs";
    adamgoose.inputs.devenv.follows = "devenv";
  };

  outputs = inputs@{ nixpkgs, devenv, flake-parts, home-manager, ... }:
    let
      lib = import ./lib { inherit inputs; };
      inherit (lib) mkHome mkDarwin mkSystem;
      inherit (flake-parts.lib) mkFlake;
    in
    mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" "x86_64-darwin" ];
      perSystem = { config, self', inputs', pkgs, system, ... }: {
        packages = import ./pkgs { inherit pkgs; };

        devShells = {
          default = pkgs.mkShell {
            nativeBuildInputs = [
              inputs'.home-manager.packages.home-manager
            ];
          };
        };
      };
      flake = {
        overlays.default = import ./overlay {
          inherit nixpkgs;
        };

        homeConfigurations = {
          bridge = mkHome {
            name = "bridge";
            username = "erik.jenks";
            system = "aarch64-darwin";
            features = [ "cli" "ide-full" "aws" "k8s" "iac" "ruby" ];
          };
        };

        darwinConfigurations = {
          bridge = mkDarwin {
            name = "bridge";
            username = "erik.jenks";
            system = "aarch64-darwin";
            features = [ ];
            homeFeatures = [ "cli" "ide-full" "aws" "k8s" "iac" "ruby" ];
          };

          erik.home = mkDarwin {
            name = "erik.home";
            username = "Erik";
            system = "x86_64-darwin";
            features = [  ];
            homeFeatures = [ "cli" "ide-full" "aws" "k8s" "iac" ];
          }
        };

        nixosConfigurations = { };
      };
    };
}
