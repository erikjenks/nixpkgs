{
  inputs,
  cell,
}: let
  inherit (inputs) cells darwin home-manager;
  l = inputs.nixpkgs.lib // builtins;
in {
  mkDarwinSystem = {
    username,
    system ? "aarch64-darwin",
    darwinModules ? [],
    homeModules ? [],
  }:
    darwin.lib.darwinSystem {
      inherit system;
      pkgs = cell.nixpkgs.default;
      modules =
        [
          home-manager.darwinModules.home-manager
          (cell.darwinModules.home homeModules)
          cell.darwinModules.default
        ]
        ++ darwinModules;
      specialArgs = {
        inherit inputs username;
        unstable = cell.nixpkgs.unstable;
      };
    };
  importModules = dir:
    l.mapAttrs'
    (file: type:
      l.nameValuePair
      (l.removeSuffix ".nix" file)
      (import (dir + /${file})))
    (l.filterAttrs
      (file: type: type == "directory" || file != "default.nix")
      (l.readDir dir));
}
