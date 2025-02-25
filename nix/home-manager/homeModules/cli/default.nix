{pkgs, ...}: {
  imports = [
    ./git.nix
    ./ssh.nix
    ./zellij.nix
    ./zsh.nix
  ];
  home.packages = with pkgs; [
    fx
    gh
    jq
    enc
    gum
    htop
    wget
    doggo
    unzip
    watch
    ffmpeg
    cachix
    httpie
    rclone
    hostctl
    jwt-cli
    neofetch
  ];

  xdg.enable = true;

  programs.btop = {
    enable = true;
    settings = {
      vim_keys = true;
    };
  };

  programs.bat = {
    enable = true;
    config = {
      pager = "less -FR --mouse";
    };
  };

  home.shellAliases = {
    cat = "bat";
    nixpkgs = "cd ~/.config/nixpkgs";
    yt = "yt-dlp";
  };
}
