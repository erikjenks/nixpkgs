# Your overlays go here (see https://nixos.wiki/wiki/Overlays)
{ nixpkgs, ... }:
final: prev: {

  #

} // import ../pkgs { pkgs = final; }
