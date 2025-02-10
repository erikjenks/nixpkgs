{flavor ? "macchiato"}: {pkgs, ...}: let
  k9s = pkgs.fetchFromGitHub {
    owner = "catppuccin";
    repo = "k9s";
    rev = "fdbec82"; # 2024-07-20
    sha256 = "sha256-9h+jyEO4w0OnzeEKQXJbg9dvvWGZYQAO4MbgDn6QRzM=";
  };
  btop = pkgs.fetchFromGitHub {
    owner = "catppuccin";
    repo = "btop";
    rev = "89ff712eb62747491a76a7902c475007244ff202";
    sha256 = "sha256-J3UezOQMDdxpflGax0rGBF/XMiKqdqZXuX4KMVGTxFk=";
  };
  bat = pkgs.fetchFromGitHub {
    owner = "catppuccin";
    repo = "bat";
    rev = "ba4d16880d63e656acced2b7d4e034e4a93f74b1";
    sha256 = "sha256-6WVKQErGdaqb++oaXnY3i6/GuH2FhTgK0v4TN4Y0Wbw=";
  };
  yazi = pkgs.fetchFromGitHub {
    owner = "catppuccin";
    repo = "yazi";
    rev = "5d3a1ee"; # 2024-12-17
    sha256 = "sha256-UVcPdQFwgBxR6n3/1zRd9ZEkYADkB5nkuom5SxzPTzk=";
  };
  starship = pkgs.fetchFromGitHub {
    owner = "catppuccin";
    repo = "starship";
    rev = "5629d2356f62a9f2f8efad3ff37476c19969bd4f";
    sha256 = "sha256-nsRuxQFKbQkyEI4TXgvAjcroVdG+heKX5Pauq/4Ota0=";
  };
  process-compose = pkgs.fetchFromGitHub {
    owner = "catppuccin";
    repo = "process-compose";
    rev = "b0c48aa"; # 2024-07-20
    sha256 = "sha256-uqJR9OPrlbFVnWvI3vR8iZZyPSD3heI3Eky4aFdT0Qo=";
  };
  lazygit = pkgs.fetchFromGitHub {
    owner = "catppuccin";
    repo = "lazygit";
    rev = "d3c95a6"; # 2024-10-14
    sha256 = "sha256-b2SoIeXT1BaoxvEeQ0VaPmnBND+7qUe342kOIkyOcAc=";
  };
in {
  # Ghostty
  xdg.configFile."ghostty/config".text = ''
    theme = catppuccin-${flavor}
  '';

  # Wezterm
  programs.wezterm.extraConfig = ''
    color_scheme = "Catppuccin Macchiato",
  '';

  # Helix
  programs.helix = {
    settings = {
      theme = "catppuccin_custom";
    };
    themes = {
      catppuccin_custom = {
        inherits = "catppuccin_${flavor}";
        "ui.background" = {
          fg = "text";
        };
        "diagnostic.unnecessary" = {
          underline = {
            color = "surface2";
            style = "curl";
          };
        };
      };
    };
  };

  # k9s
  xdg.configFile."k9s/skins".source = "${k9s}/dist";
  programs.k9s.settings = {
    k9s = {
      ui = {
        skin = "catppuccin-${flavor}-transparent";
      };
    };
  };

  # btop
  xdg.configFile."btop/themes".source = "${btop}/themes";
  programs.btop.settings.color_theme = "catppuccin_${flavor}";

  # bat
  programs.bat = {
    config.theme = "catppuccin";
    themes = {
      catppuccin = {
        src = bat;
        file = "Catppuccin-${flavor}.tmTheme";
      };
    };
  };

  # yazi
  xdg.configFile."yazi/theme.toml".source = "${yazi}/themes/${flavor}/catppuccin-${flavor}-blue.toml";

  # zellij
  programs.zellij.settings.theme = "catppuccin-${flavor}";

  # starship
  programs.starship.settings =
    {
      palette = "catppuccin_${flavor}";
    }
    // builtins.fromTOML (builtins.readFile (starship + /palettes/${flavor}.toml));

  # Process Compose
  xdg.configFile."process-compose/theme.yml".source = "${process-compose}/themes/catppuccin-${flavor}.yaml";

  # lazygit
  xdg.configFile."lazygit/config.yml".source = "${lazygit}/themes-mergable/${flavor}/blue.yml";
}
