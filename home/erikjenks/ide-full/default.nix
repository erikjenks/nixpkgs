{ pkgs, unstable, ... }: {
  imports = [
    ../ide
  ];

  home.packages = with pkgs; [
    go
    mkcert
    asciinema
    postgresql
    redis
  ] ++ (with unstable; [
    ## 
  ]);

  programs.zsh.oh-my-zsh.plugins = [
    "golang"
  ];

  programs.zsh.initExtra = ''
    export PATH=$HOME/go/bin:$PATH
  '';
}
