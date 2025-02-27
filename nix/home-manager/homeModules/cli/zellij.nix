{
  pkgs,
  inputs,
  ...
}: {
  programs.zellij = {
    enable = true;
    settings = {
      pane_frames = false;
    };
  };
}
