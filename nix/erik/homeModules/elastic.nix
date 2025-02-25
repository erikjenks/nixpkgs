{
  lib,
  inputs,
  ...
}: {
  programs.ssh = {
    enable = true;
    controlPath = "~/.ssh.%C";
    matchBlocks = {
      "github.com" = {
        identityFile = "/Users/erik.jenks/.ssh/id_ed25519";
      };
    };
  };

  programs.git = {
    extraConfig = {
      url = {
        "ssh://git@github.com/" = {
          insteadOf = "https://github.com/";
        };
      };
    };
  };
}
