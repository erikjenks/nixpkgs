{
  lib,
  ...
}: {
  programs.ssh = {
    enable = true;
    controlPath = "~/.ssh.%C";
    matchBlocks = {
      "*" = {
        extraOptions = {
          IdentityAgent = "\"~/Library/Group Containers/2BUA8C4SC.com.1password/t/agent.sock\"";
        };
      };
      "*.tsh.bridgeops.sh tsh.bridgeops.sh" =
        lib.hm.dag.entryBefore [
          "*.tsh.bridgeops.sh !tsh.bridgeops.sh"
        ] {
          identityFile = "/Users/erik.jenks/.tsh/keys/tsh.bridgeops.sh/erikjenks";
          certificateFile = "/Users/erik.jenks/.tsh/keys/tsh.bridgeops.sh/erikjenks-ssh/tsh.bridgeops.sh-cert.pub";
          extraOptions = {
            UserKnownHostsFile = "/Users/erik.jenks/.tsh/known_hosts";
          };
        };
      "*.tsh.bridgeops.sh !tsh.bridgeops.sh" = {
        port = 3022;
        proxyCommand = "tsh proxy ssh --cluster=tsh.bridgeops.sh --proxy=tsh.bridgeops.sh%r@%h:%p";
      };
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
