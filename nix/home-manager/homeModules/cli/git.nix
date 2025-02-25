{
  pkgs,
  lib,
  ...
}: {
  programs.git = {
    enable = true;
    userName = "Erik Jenks";
    userEmail = lib.mkDefault "erikjenks@gmail.com";
    ignores = [
      ".direnv"
    ];
    extraConfig = {
      core.pager = "cat";
      url = {
        "ssh://git@github.com/" = {
          insteadOf = "https://github.com/";
        };
      };
      ghq = {
        root = "~/code";
      };
    };
  };
  home.packages = with pkgs; [
    ghq
  ];
  home.shellAliases = {
    gbc = "git checkout -b";
    gco = "git checkout";
    gl = "git pull";
    gbd = "git branch -d";
    gb = "git branch";
    gs = "git status";
  };
}
