{
  pkgs,
  unstable,
  ...
}: {
  programs.helix = {
    enable = true;
    package = unstable.helix;
    extraPackages = with pkgs; [
      nil
      delve
      gopls
      deadnix
      alejandra
      terraform-ls
      yaml-language-server
      nodePackages.typescript-language-server
    ];
    settings = {
      editor = {
        bufferline = "multiple";
        cursorline = true;
        color-modes = true;
        line-number = "relative";
        cursor-shape = {
          insert = "bar";
        };
        indent-guides = {
          render = true;
          skip-levels = 1;
          character = "▏";
        };
        lsp = {
          display-messages = true;
        };
        whitespace = {
          render = {
            tab = "all";
          };
        };
        theme = "catppuccin_macchiato";

        end-of-line-diagnostics = "hint";
        inline-diagnostics = {
          cursor-line = "error";
          other-lines = "error";
        };
      };
    };
    languages = {
      language-server = {
        statix = {
          command = "statix check";
          args = ["check" "--stdin" "--format=json"];
        };
        deadnix.command = "deadnix";
        tailwindcss = {
          command = "tailwindcss-language-server";
          args = ["--stdio"];
          config = {
            userLanguages = {tsx = "tsx";};
          };
        };
      };
      language = [
        {
          name = "nix";
          auto-format = true;
          formatter = {
            command = "alejandra";
          };
          language-servers = ["nil" "statix" "deadnix"];
        }
        {
          name = "typescript";
          auto-format = true;
          language-servers = ["typescript-language-server" "vscode-eslint-language-server"];
          formatter = {
            command = "prettier";
            args = ["--parser" "typescript"];
          };
        }
        {
          name = "tsx";
          auto-format = true;
          language-servers = ["typescript-language-server" "vscode-eslint-language-server"];
          formatter = {
            command = "prettier";
            args = ["--parser" "typescript"];
          };
        }
      ];
    };
  };
}
