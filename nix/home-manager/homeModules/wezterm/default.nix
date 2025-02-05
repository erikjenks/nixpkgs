{
  pkgs,
  lib,
  ...
}: {
  programs.wezterm = {
    enable = true;
    package = pkgs.wezterm;
    enableZshIntegration = true;
    extraConfig = lib.mkMerge [
      (lib.mkBefore ''
        return {
          enable_wayland = false,
          front_end = "WebGpu",
          font = wezterm.font 'FiraCode Nerd Font Mono',
          font_size = 16.0,

          enable_tab_bar = false,
          macos_window_background_blur = 30,
          window_decorations = 'RESIZE',

          window_background_opacity = .90,
          hide_mouse_cursor_when_typing = false,
      '')
      (lib.mkAfter ''
        }
      '')
    ];
  };
}
