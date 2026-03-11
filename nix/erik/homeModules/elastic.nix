{
  lib,
  pkgs,
  ...
}: {
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks = {
      "*" = {
        controlPath = "~/.ssh.%C";
      };
      "github.com" = {
        identityFile = "/Users/erik.jenks/.ssh/id_ed25519";
      };
    };
  };

  programs.git = {
    settings = {
      user.email = lib.mkForce "erik.jenks@elastic.co";
      url = {
        "ssh://git@github.com/" = {
          insteadOf = "https://github.com/";
        };
      };
    };
  };
  home.packages = with pkgs; [
    pwgen
  ];
}
