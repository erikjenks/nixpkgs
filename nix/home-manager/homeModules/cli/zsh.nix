{
  pkgs,
  lib,
  ...
}: {
  programs.zsh = {
    enable = true;

    # zplug clones GitHub over SSH by default; that prompts for keys and can
    # corrupt the install progress line in GUI terminals (Wezterm). HTTPS is
    # enough for these public plugins (git can still use SSH via ~/.ssh/config).
    sessionVariables.ZPLUG_PROTOCOL = "HTTPS";

    autocd = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    history.share = true;

    profileExtra = ''
      eval "$(/opt/homebrew/bin/brew shellenv)"

      # >>> coursier install directory >>>
      export PATH="$PATH:/Users/erik.jenks/Library/Application Support/Coursier/bin"
      # <<< coursier install directory <<<
    '';

    oh-my-zsh = {
      enable = true;
      custom = "$HOME/.oh-my-zsh/custom";
      plugins =
        [
          "fzf"
          "gcd"
          "direnv"
          "vi-mode"
          "colored-man-pages"
        ]
        ++ lib.lists.optional (pkgs.stdenv.isDarwin) "macos";
    };

    zplug = {
      enable = true;
      plugins = [
        {
          name = "Aloxaf/fzf-tab";
        }
      ];
    };

    initContent = lib.mkMerge [
      (lib.mkOrder 500 ''
        # macOS GUI apps (e.g. Wezterm) often start without SSH_AUTH_SOCK; loginwindow's
        # agent is still available via launchd.
        if [[ -z "$SSH_AUTH_SOCK" && "$OSTYPE" == darwin* ]]; then
          _hm_ssh_sock="$(launchctl getenv SSH_AUTH_SOCK 2>/dev/null)"
          if [[ -n "$_hm_ssh_sock" ]]; then
            export SSH_AUTH_SOCK="$_hm_ssh_sock"
          fi
          unset _hm_ssh_sock
        fi
      '')
      ''
      # disable sort when completing `git checkout`
      zstyle ':completion:*:git-checkout:*' sort false
      # set descriptions format to enable group support
      # NOTE: don't use escape sequences here, fzf-tab will ignore them
      zstyle ':completion:*:descriptions' format '[%d]'
      # set list-colors to enable filename colorizing
      zstyle ':completion:*' list-colors ''${(s.:.)LS_COLORS}
      # force zsh not to show completion menu, which allows fzf-tab to capture the unambiguous prefix
      zstyle ':completion:*' menu no
      # preview directory's content with eza when completing cd
      zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
      # switch group using `<` and `>`
      zstyle ':fzf-tab:*' switch-group '<' '>'
      if [ -f ~/.local_zshrc ]; then
        source ~/.local_zshrc
      fi
    ''
    ];
  };

  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;
  programs.fzf.enable = true;
  programs.fzf.enableZshIntegration = true;
  programs.eza.enable = true;
  programs.eza.enableZshIntegration = true;

  home.file.".oh-my-zsh/custom".recursive = true;
  home.file.".oh-my-zsh/custom".source = ./files/oh-my-zsh-custom;

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      gcloud.disabled = true;
      command_timeout = 10000;
    };
  };
}
