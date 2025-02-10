{pkgs, ...}: {
  programs.git = {
    enable = true;
    userName = "Erik Jenks";
    userEmail = "erikjenks@gmail.com";
    ignores = [
      ".direnv"
    ];
    extraConfig = {
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
}
