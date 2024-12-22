{ pkgs, ... }: {

  programs.vscode = {
    enable = true;
    extensions = with pkgs.vscode-extensions; [
      arcticicestudio.nord-visual-studio-code
      asvetliakov.vscode-neovim
      # vscodevim.vim
      jnoortheen.nix-ide
    ];

    userSettings = {
      "update.mode" = "none";
      "workbench.colorTheme" = "Nord";
      "vscode-neovim.neovimExecutablePaths.linux" = pkgs.neovim + "/bin/nvim";
    };
  };

}
