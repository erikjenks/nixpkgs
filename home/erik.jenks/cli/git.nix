{ pkgs, ... }:

{
  programs.git = {
    enable = true;
    userName = "erikjenks";
    userEmail = "erik.jenks@getbridge.com";
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
  };

}
