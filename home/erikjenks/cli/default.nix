{ inputs, pkgs, ... }: {
  imports = [
    ./git.nix
    ./ssh.nix
    ./tmux.nix
    ./zsh.nix
    ./unstable.nix
  ];
  home.packages = with pkgs; [
    ripgrep
    jq
    enc
    gum
    htop
    wget
    xplr
    cachix
    rclone
    exercism
    keka
    heroku
    inputs.devenv.packages.${pkgs.system}.default
  ];

  programs.oh-my-posh = {
    enable = true;
    enableZshIntegration = true;
    settings = builtins.fromJSON (builtins.unsafeDiscardStringContext (builtins.readFile ./files/.omp.json));
  };

  xdg.enable = true;
}
