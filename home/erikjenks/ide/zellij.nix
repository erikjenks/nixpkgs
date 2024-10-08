{
    pkgs,
    lib,
    ...
  }: {
      programs.zellij = {
          enable = true;
          settings = {
              theme = "catpuccin-macchiato";
              pane_frames = false;
            };
        };
    }

