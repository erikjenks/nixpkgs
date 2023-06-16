{ pkgs, ... }:

{
  programs.git = {
    enable = true;
    userName = "erikjenks";
    userEmail = "erik.jenks@getbridge.com";
    ignores = [
      ".direnv"
    ];
  };

}
