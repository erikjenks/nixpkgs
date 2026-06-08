{
  inputs,
  cell,
}: {
  default = {pkgs, ...}: {
    systemd.user.startServices = pkgs.lib.mkIf pkgs.stdenv.isLinux "sd-switch";
    home.stateVersion = "22.05";
  };
  elastic = import ./elastic.nix;
}
