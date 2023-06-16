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

    # Utilities for building our flake
    flake-utils.url = "github:numtide/flake-utils";

    nix-npm-buildpackage.url = "github:serokell/nix-npm-buildpackage";
    nix-npm-buildpackage.inputs.nixpkgs.follows = "nixpkgs";

    devenv.url = "github:cachix/devenv/latest";
    # devenv.inputs.nixpkgs.follows = "nixpkgs";

    # Extra flakes for modules, packages, etc
    hardware.url = "github:nixos/nixos-hardware"; # Convenience modules for hardware-specific quirks
  };

  outputs = { nixpkgs, nixpkgs-unstable, home-manager, nix-npm-buildpackage, flake-utils, devenv, ... }@inputs:
    let
      lib = import ./lib { inherit inputs; };
      inherit (lib) mkHome;

      # Bring some functions into scope (from builtins and other flakes)
      inherit (builtins) attrValues;
      inherit (flake-utils.lib) eachSystemMap defaultSystems;
      eachDefaultSystemMap = eachSystemMap defaultSystems;
    in
    rec {
      # If you want to use packages exported from other flakes, add their overlays here.
      # They will be added to your 'pkgs'
      overlays = {
        default = import ./overlay {
          inherit nixpkgs devenv;
        }; # Our own overlay
        nix-npm-buildpackage = nix-npm-buildpackage.overlays.default;
      };

      # Home configurations
      # Accessible via 'home-manager'
      homeConfigurations = {
        "bridge" = mkHome {
          name = "bridge";
          username = "erik.jenks";
          homeDirectory = "/Users/erik.jenks";
          system = "aarch64-darwin";
          features = [ "cli" "ide-full" "aws" "k8s" "iac" "ruby"];
        };
      };

      # Packages
      # Accessible via 'nix build'
      packages = eachDefaultSystemMap (system:
        # Propagate nixpkgs' packages, with our overlays applied
        import nixpkgs { inherit system; overlays = attrValues overlays; config.allowUnfree = true; }
      );

      packages-unstable = eachDefaultSystemMap (system:
        import nixpkgs-unstable { inherit system; overlays = attrValues overlays; config.allowUnfree = true; }
      );

      # Devshell for bootstrapping
      # Accessible via 'nix develop'
      devShells = eachDefaultSystemMap (system: {
        default = import ./shell.nix { pkgs = packages.${system}; };
      });
    };
}
