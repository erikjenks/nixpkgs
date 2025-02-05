{
  pkgs,
  unstable,
  ...
}: let
  eslint-ls = with unstable;
    buildNpmPackage rec {
      pname = "vscode-langservers-extracted";
      version = "4.8.0";

      src = fetchFromGitHub {
        owner = "hrsh7th";
        repo = pname;
        rev = "v${version}";
        hash = "sha256-sGnxmEQ0J74zNbhRpsgF/cYoXwn4jh9yBVjk6UiUdK0=";
      };

      npmDepsHash = "sha256-LFWC87Ahvjf2moijayFze1Jk0TmTc7rOUd/s489PHro=";

      buildPhase = let
        extensions =
          if stdenv.isDarwin
          then "${vscodium}/Applications/VSCodium.app/Contents/Resources/app/extensions"
          else "${vscodium}/lib/vscode/resources/app/extensions";
      in ''
        npx babel ${extensions}/css-language-features/server/dist/node \
          --out-dir lib/css-language-server/node/
        npx babel ${extensions}/html-language-features/server/dist/node \
          --out-dir lib/html-language-server/node/
        npx babel ${extensions}/json-language-features/server/dist/node \
          --out-dir lib/json-language-server/node/
        cp -r ${vscode-extensions.dbaeumer.vscode-eslint}/share/vscode/extensions/dbaeumer.vscode-eslint/server/out \
          lib/eslint-language-server
      '';

      meta = with lib; {
        description = "HTML/CSS/JSON/ESLint language servers extracted from vscode";
        homepage = "https://github.com/hrsh7th/vscode-langservers-extracted";
        license = licenses.mit;
        maintainers = with maintainers; [lord-valen];
      };
    };
in {
  programs.helix = {
    enable = true;
    package = unstable.helix;
    extraPackages = with pkgs; [
      nil
      delve
      gopls
      kdlfmt
      deadnix
      alejandra
      eslint-ls
      terraform-ls
      lua-language-server
      yaml-language-server
      tailwindcss-language-server
      unstable.vue-language-server
      unstable.nodePackages.prettier
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
        typescript-language-server.config = {
          plugins = [
            {
              name = "@vue/typescript-plugin";
              location = "./node_modules";
              languages = ["vue"];
            }
          ];
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
          language-servers = ["typescript-language-server" "tailwindcss" "vscode-eslint-language-server"];
          formatter = {
            command = "prettier";
            args = ["--parser" "typescript"];
          };
        }
        {
          name = "vue";
          language-servers = ["typescript-language-server" "vscode-eslint-language-server" "vuels" "efm"];
          auto-format = true;
          formatter = {
            command = "prettier";
            args = ["--parser" "vue"];
          };
        }
        {
          name = "kdl";
          auto-format = true;
          formatter = {
            command = "kdlfmt";
            args = ["format" "-"];
          };
        }
      ];
    };
  };
}
