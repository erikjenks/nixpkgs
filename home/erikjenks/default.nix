{ inputs, lib, username, features, ... }:

let
  inherit (builtins) map pathExists filter;
in
{
  # Import features that have modules
  imports = filter pathExists (map (feature: ./${feature}) features);

  nixpkgs.config.allowUnfree = true;
  systemd.user.startServices = "sd-switch";
  programs.git.enable = true;

  home.stateVersion = "23.05";
}
