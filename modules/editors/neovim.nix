{inputs, ...}: {
  flake.nixosModules.neovim = {...}: {
    imports = [
      inputs.nvf.nixosModules.default
    ];

    programs.nvf = {
      enable = true;
      settings.vim = {
        enableLuaLoader = true;

        viAlias = true;
        vimAlias = true;

        spellcheck = {
          enable = true;
          languages = [
            "en"
            "en_ca"
          ];
        };

        undoFile.enable = true;
        searchCase = "smart";
        options = {
          cursorlineopt = "line";
          shiftwidth = 2;
          scrolloff = 10;
        };

        lsp = {
          enable = true;
          formatOnSave = true;
        };

        languages = {
          nix = {
            enable = true;
            extraDiagnostics.enable = true;
            format.enable = true;
            format.type = ["alejandra"];
            treesitter.enable = true;

            lsp = {
              enable = true;
              servers = ["nil"];
            };
          };

          markdown = {
            enable = true;
            extraDiagnostics.enable = true;
            format.enable = true;
            format.type = ["deno"];
            treesitter.enable = true;

            lsp = {
              enable = true;
              servers = ["marksman"];
            };

            extensions = {
              markview-nvim.enable = true;
            };
          };
        };

        visuals = {
          nvim-scrollbar.enable = true;
          nvim-web-devicons.enable = true;
          nvim-cursorline.enable = true;

          cinnamon-nvim.enable = true;
          fidget-nvim.enable = true;
          highlight-undo.enable = true;
          indent-blankline.enable = true;

          cellular-automaton.enable = true;
        };

        statusline.lualine.enable = true;
        options.termguicolors = true;

        theme = {
          enable = true;
          name = "catppuccin";
          style = "mocha";
          transparent = true;
        };

        autocomplete = {
          nvim-cmp.enable = true;
        };

        snippets.luasnip.enable = true;
      };
    };
  };
}
