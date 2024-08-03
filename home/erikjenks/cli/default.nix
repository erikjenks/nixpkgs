{ pkgs, ... }: {
  imports = [
    ./git.nix
    ./ssh.nix
    ./tmux.nix
    ./zsh.nix
    ./unstable.nix
  ];
  home.packages = with pkgs; [
    asdf-vm
    ripgrep
    jq
    enc
    gum
    htop
    wget
    xplr
    doggo
    cachix
    devenv
    rclone
    shared-mime-info
    libpqxx
    yarn
    heroku
  ];

  programs.oh-my-posh = {
    enable = true;
    enableZshIntegration = true;
    settings = builtins.fromJSON (builtins.unsafeDiscardStringContext (builtins.readFile ./files/.omp.json));
  };

  xdg.enable = true;
}
