{
  description = "My Nix configurations";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    nixos.follows = "nixpkgs";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    std.url = "github:divnix/std";
    std.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager/release-24.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    darwin.url = "github:lnl7/nix-darwin/nix-darwin-24.11";
    darwin.inputs.nixpkgs.follows = "nixpkgs";

    devenv.url = "github:cachix/devenv/v1.3.1";
    zjstatus.url = "github:dj95/zjstatus/v0.19.1";
    helix.url = "github:helix-editor/helix";
  };

  outputs = {std, ...} @ inputs:
    std.growOn
    {
      inherit inputs;
      cellsFrom = ./nix;
      cellBlocks = with std.blockTypes; [
        (installables "packages")

        (functions "lib")
        (functions "homeModules")
        (functions "darwinModules")
        (functions "darwinConfigurations")

        (pkgs "nixpkgs")
      ];
      nixpkgsConfig = {
        allowUnfree = true;
      };
    }
    {
      packages = std.harvest (inputs.self) [
        ["kubeswitch" "packages"]
        ["kubetap" "packages"]
        ["truss-cli" "packages"]
      ];

      darwinConfigurations =
        (std.harvest (inputs.self) [
          ["erik" "darwinConfigurations"]
        ])
        .aarch64-darwin;
    };

  nixConfig = {
    extra-substituters = [
      "https://devenv.cachix.org"
      "https://helix.cachix.org"
    ];
    extra-trusted-public-keys = [
      "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
      "helix.cachix.org-1:ejp9KQpR1FBI2onstMQ34yogDm4OgU2ru6lIwPvuCVs="
    ];
  };
}
