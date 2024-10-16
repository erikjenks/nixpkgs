{ pkgs, ... }:

{
  programs.git = {
    enable = true;
    userName = "erikjenks";
    userEmail = "erikjenks@gmail.com";
    ignores = [
      ".direnv"
      ".direnv/*"
      ".devenv"
      ".devenv/*"
      ".devenv.*"
      ".envrc"
    ];
    extraConfig = {
      ghq = {
        root = "~/src";
      };
    };
  };

  home.packages = with pkgs; [
    ghq
  ];

  home.shellAliases = {
    gcd = "dst=$(ghq list | fzf --height=~10) && cd $(ghq root)/$dst";
    gs = "git status";
    gb = "git branch";
    gbc = "git branch --checkout";
    gco = "git checkout";
  };

}
