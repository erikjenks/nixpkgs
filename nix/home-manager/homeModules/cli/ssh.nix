{
  pkgs,
  lib,
  ...
}: {
  programs.ssh = {
    enable = true;
    matchBlocks = {
      mildred = {
        user = "admin";
      };
      "*" = {
        # Load keys into ssh-agent as you use them (passphrase once per boot/session).
        addKeysToAgent = "yes";
        # macOS OpenSSH: store passphrases in Keychain (no effect on Nixpkgs OpenSSH on Linux).
        extraOptions = lib.optionalAttrs pkgs.stdenv.isDarwin {
          UseKeychain = "yes";
        };
      };
    };
  };
}
