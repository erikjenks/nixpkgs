{flavor ? ""}: {pkgs, ...}: let
  dashFlavor =
    if flavor != ""
    then "-" + flavor
    else "";
  underscoreFlavor =
    if flavor != ""
    then "_" + flavor
    else "";

  k9s = pkgs.fetchFromGitHub {
    owner = "sasoria";
    repo = "k9s-theme";
    rev = "22cfbb2"; # 2024-12-27
    sha256 = "sha256-JbeuAlrLjPjex97Y6S/UPRn7AGK237zBWmtHxvptawM=";
  };
  btop = pkgs.fetchFromGitHub {
    owner = "rose-pine";
    repo = "btop";
    rev = "6d6abdc"; # 2023-07-18
    sha256 = "sha256-JbeuAlrLjPjex97Y6S/UPRn7AGK237zBWmtHxvptawM=";
  };
  zellij = pkgs.fetchFromGitHub {
    owner = "rose-pine";
    repo = "zellij";
    rev = "b3b2fd3"; # 2025-01-17
    sha256 = "sha256-JbeuAlrLjPjex97Y6S/UPRn7AGK237zBWmtHxvptawM=";
  };
in {
  # Ghostty
  xdg.configFile."ghostty/config".text = ''
    theme = rose-pine${dashFlavor}
  '';

  # Wezterm
  programs.wezterm.extraConfig = ''
    color_scheme = "rose-pine${dashFlavor}",
  '';

  # Helix
  programs.helix = {
    settings = {
      theme = "rose_pine${underscoreFlavor}";
    };
  };

  # k9s
  xdg.configFile."k9s/skins".source = k9s;
  programs.k9s.settings.k9s.ui.skin = "rose-pine${dashFlavor}";

  # btop
  xdg.configFile."btop/themes".source = btop;
  programs.btop.settings.color_theme = "rose-pine${dashFlavor}";

  # bat (missing)
  # yazi (missing)

  # zellij
  xdg.configFile."zellij/themes".source = "${zellij}/dist";
  programs.zellij.settings.theme = "rose-pine${dashFlavor}";

  # starship
  # process-compose
}
