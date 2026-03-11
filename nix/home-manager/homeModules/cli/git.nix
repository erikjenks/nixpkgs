{
  pkgs,
  lib,
  ...
}: {
  programs.git = {
    enable = true;
    ignores = [
      ".direnv"
      "logs"
      ".bsp"
      ".java-version"
      ".windsurf"
    ];
    settings = {
      user = {
        name = "Erik Jenks";
        email = lib.mkDefault "erikjenks@gmail.com";
      };
      core = {
        editor = "hx --wait";
        pager = "cat";
      };
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
