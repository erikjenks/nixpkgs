{ pkgs, ... }: {

  home.packages = with pkgs; [
    chruby
  ];

  programs.zsh.oh-my-zsh.plugins = [
    "chruby"
  ];
}
