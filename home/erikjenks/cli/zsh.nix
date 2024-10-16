{ pkgs, name, lib, username, homeDirectory, ... }:

{
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    oh-my-zsh = {
      enable = true;
      custom = "$HOME/.oh-my-zsh/custom";
      plugins = [
        "direnv"
        "fzf"
        "git"
        "vi-mode"
      ]
      ++ lib.lists.optional (pkgs.stdenv.isDarwin) "macos"
      ;
    };

    zplug = {
      enable = true;
      plugins = [ ];
    };

    initExtra = ''
        . "${pkgs.asdf-vm}/share/asdf-vm/asdf.sh"
      . "${pkgs.asdf-vm}/share/asdf-vm/completions/asdf.bash"
    '';
  };

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;
  programs.fzf.enable = true;
  programs.fzf.enableZshIntegration = true;

  programs.bat = {
    enable = true;
    config = {
      pager = "less -FR --mouse";
      theme = "catppuccin";
    };
    themes = {
      catppuccin = {
        src = pkgs.fetchFromGitHub {
          owner = "catppuccin";
          repo = "bat"; # Bat uses sublime syntax for its themes
          rev = "ba4d16880d63e656acced2b7d4e034e4a93f74b1";
          sha256 = "sha256-6WVKQErGdaqb++oaXnY3i6/GuH2FhTgK0v4TN4Y0Wbw=";
        };
        file = "/Catppuccin-macchiato.tmTheme";
      };
    };
  };

  home.shellAliases = {
    cat = "bat";
    reload = "home-manager switch --flake '${homeDirectory}/.config/nixpkgs#${name}' && source ~/.zshrc";
    nixpkgs = "cd ${homeDirectory}/.config/nixpkgs";
    rgf = "rg --files | rg";
  };
}

