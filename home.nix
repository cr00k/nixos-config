# home.nix — user-level declarative config via home-manager
# Manages dotfiles, shell, editor, browser extensions, and GNOME settings
#
# Changes here apply with:  sudo nixos-rebuild switch --flake .#thinkpad

{ config, pkgs, ... }:

{
  home.username      = "rok";
  home.homeDirectory = "/home/rok";
  home.stateVersion  = "25.11";      # do not change after first install
  home.file.".config/monitors.xml".source = ./monitors.xml;
  home.file."Pictures/wallpaper.jpg".source = ./wallpaper.jpg;

  # Let home-manager manage itself
  programs.home-manager.enable = true;
  
  # ─────────────────────────────────────────────
  # Git
  # ─────────────────────────────────────────────
  programs.bash = {
    enable = true;
    shellAliases = {
      # Modern replacements
      ls   = "eza --icons";
      ll   = "eza -lah --icons --git";
      lt   = "eza --tree --icons";
      cat  = "bat";
      grep = "rg";
      find = "fd";

      # NixOS shortcuts
      rebuild = "sudo nixos-rebuild switch --flake ~/.config/nixos-config#thinkpad";
      update  = "cd ~/.config/nixos-config && nix flake update && sudo nixos-rebuild switch --flake .#thinkpad";
      cleanup = "sudo nix-collect-garbage -d";
      bootclean = "sudo nixos-rebuild boot --flake ~/.config/nixos-config#thinkpad";
      sync = "cd ~/.config/nixos-config && git add -A && git commit -m 'update flake.lock' && git push";

      # Git shortcuts
      g  = "git";
      lg = "lazygit";

      # Navigation
      ".."  = "cd ..";
      "..." = "cd ../..";
    };

    initExtra = ''
      # Rust / Cargo
      export PATH="$HOME/.cargo/bin:$PATH"

      # npm globals (for Claude Code CLI etc.)
      export PATH="$HOME/.npm-global/bin:$PATH"

      # Claude Code CLI
      export PATH="$HOME/.local/bin:$PATH"
    '';
  };

  # ─────────────────────────────────────────────
  # Git
  # ─────────────────────────────────────────────
  programs.git = {
  enable = true;
  settings = {
    user.name  = "Rok";
    user.email = "rok@rkokalj.si";
    alias = {
      lg = "log --oneline --graph --decorate --all";
      st = "status -sb";
      co = "checkout";
      br = "branch";
    };
    init.defaultBranch   = "main";
    pull.rebase          = true;
    push.autoSetupRemote = true;
    core.editor          = "nvim";
    diff.tool            = "vimdiff";
    diff.colorMoved      = "zebra";
    merge.tool           = "vimdiff";
    credential.helper    = "store";
  };
  ignores = [ ".DS_Store" "*.swp" ".direnv" ".env" "node_modules" "target" ".vscode" ];
};

  # ─────────────────────────────────────────────
  # Tmux
  # ─────────────────────────────────────────────
  programs.tmux = {
    enable        = true;
    terminal      = "tmux-256color";
    historyLimit  = 50000;
    keyMode       = "vi";
    escapeTime    = 10;
    baseIndex     = 1;          # windows start at 1, not 0
    mouse         = true;
    prefix        = "C-b";      # screen-style prefix (change to C-b if you prefer)

    plugins = with pkgs.tmuxPlugins; [
      sensible
      yank              # clipboard support on Wayland
      {
        plugin = resurrect;    # save/restore sessions
        extraConfig = "set -g @resurrect-capture-pane-contents 'on'";
      }
      {
        plugin = continuum;    # auto-save every 15 min
        extraConfig = ''
          set -g @continuum-restore 'on'
          set -g @continuum-save-interval '15'
        '';
      }
    ];

    extraConfig = ''
      set -ag terminal-overrides ",xterm-256color:RGB"

      # Status bar — top, minimal
      set -g status-position top
      set -g status-style 'bg=default fg=white'
      set -g status-left  '#[bold]#S '
      # set -g status-right '#[fg=cyan]%H:%M #[fg=yellow]%d %b'
      set -g window-status-current-style 'bold fg=cyan'

      # Split with | and - (more intuitive than " and %)
      # bind | split-window -h -c "#{pane_current_path}"
      # bind - split-window -v -c "#{pane_current_path}"

      # Pane navigation with Alt+arrow (no prefix needed)
      bind -n M-Left  select-pane -L
      bind -n M-Right select-pane -R
      bind -n M-Up    select-pane -U
      bind -n M-Down  select-pane -D

      # Reload config
      bind r source-file ~/.config/tmux/tmux.conf \; display "Config reloaded"
    '';
  };

  # ─────────────────────────────────────────────
  # Ghostty
  # ─────────────────────────────────────────────
  programs.ghostty = {
    enable = true;
    settings = {
      font-family = "IBM Plex Mono";
      font-size = 11;
      window-decoration = false;
    
      # Transparency
      background-opacity = 0.85;
      background-blur-radius = 20;

      # Tokyo Night theme
      background = "1a1b26";
      foreground = "c0caf5";
      palette = [
        "0=#15161e"
        "1=#f7768e"
        "2=#9ece6a"
        "3=#e0af68"
        "4=#7aa2f7"
        "5=#bb9af7"
        "6=#7dcfff"
        "7=#a9b1d6"
        "8=#414868"
        "9=#f7768e"
        "10=#9ece6a"
        "11=#e0af68"
        "12=#7aa2f7"
        "13=#bb9af7"
        "14=#7dcfff"
        "15=#c0caf5"
      ];

      # Behaviour
      scrollback-limit = 10000;
      mouse-hide-while-typing = true;
      window-padding-x = 8;
      window-padding-y = 8;
    };
  };

  # ─────────────────────────────────────────────
  # Neovim
  # ─────────────────────────────────────────────
  programs.neovim = {
    enable        = true;
    defaultEditor = true;
    viAlias       = true;
    vimAlias      = true;

    # LSP servers and tools installed declaratively via Nix
    extraPackages = with pkgs; [
      # LSP servers
      rust-analyzer
      nodePackages.typescript-language-server
      nodePackages.vscode-langservers-extracted  # html, css, json, eslint
      lua-language-server
      nil               # Nix LSP
      marksman          # Markdown LSP

      # Formatters / linters
      rustfmt
      nodePackages.prettier
      stylua            # Lua formatter
      nixpkgs-fmt       # Nix formatter

      # Treesitter needs a C compiler
      gcc
    ];

    # Minimal init.lua — enough to bootstrap lazy.nvim
    # Full plugin config lives in ~/.config/nvim/lua/
    initLua = ''
      -- Options
      vim.opt.number         = true
      vim.opt.relativenumber = true
      vim.opt.tabstop        = 2
      vim.opt.shiftwidth     = 2
      vim.opt.expandtab      = true
      vim.opt.smartindent    = true
      vim.opt.wrap           = false
      vim.opt.ignorecase     = true
      vim.opt.smartcase      = true
      vim.opt.hlsearch       = false
      vim.opt.incsearch      = true
      vim.opt.termguicolors  = true
      vim.opt.scrolloff      = 8
      vim.opt.signcolumn     = "yes"
      vim.opt.updatetime     = 50
      vim.opt.undofile       = true
      vim.opt.clipboard      = "unnamedplus"  -- system clipboard

      -- Leader key
      vim.g.mapleader      = " "
      vim.g.maplocalleader = " "

      -- Keymaps
      local map = vim.keymap.set
      map("n", "<leader>e", vim.cmd.Ex)                    -- file explorer
      map("n", "<C-h>", "<C-w>h")                          -- pane navigation
      map("n", "<C-l>", "<C-w>l")
      map("n", "<C-j>", "<C-w>j")
      map("n", "<C-k>", "<C-w>k")
      map("v", "J", ":m '>+1<CR>gv=gv")                   -- move lines
      map("v", "K", ":m '<-2<CR>gv=gv")
      map("n", "<leader>s", ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>") -- rename word

      -- Bootstrap lazy.nvim
      local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
      if not vim.loop.fs_stat(lazypath) then
        vim.fn.system({
          "git", "clone", "--filter=blob:none",
          "https://github.com/folke/lazy.nvim.git",
          "--branch=stable", lazypath,
        })
      end
      vim.opt.rtp:prepend(lazypath)

      require("lazy").setup({
        -- Colorscheme
        { "folke/tokyonight.nvim",
	  priority = 1000,
	  config = function()
	    require("tokyonight").setup({
	     transparent = true,
 	     styles = {
	        sidebars = "transparent",
	        floats = "transparent",
	      },
	    })
 	   vim.cmd.colorscheme("tokyonight-night")
	  end },

        -- Fuzzy finder
        { "nvim-telescope/telescope.nvim",
          dependencies = { "nvim-lua/plenary.nvim" },
          keys = {
            { "<leader>ff", "<cmd>Telescope find_files<cr>" },
            { "<leader>fg", "<cmd>Telescope live_grep<cr>" },
            { "<leader>fb", "<cmd>Telescope buffers<cr>" },
          }},

        -- Treesitter
	{ "nvim-treesitter/nvim-treesitter",
	  build = ":TSUpdate",
	  config = function()
	    require("nvim-treesitter").setup({
	      ensure_installed = { "rust", "javascript", "typescript",
		                   "lua", "nix", "markdown", "json", "toml" },
	      highlight = { enable = true },
	    })
	  end },

        -- LSP (nvim 0.11+ native style)
	{ "neovim/nvim-lspconfig",
	  config = function()
	    vim.lsp.config("rust_analyzer", {})
	    vim.lsp.config("ts_ls", {})
	    vim.lsp.config("nil_ls", {})
	    vim.lsp.config("marksman", {})
	    vim.lsp.enable({ "rust_analyzer", "ts_ls", "nil_ls", "marksman" })
	    vim.keymap.set("n", "gd", vim.lsp.buf.definition)
	    vim.keymap.set("n", "K",  vim.lsp.buf.hover)
	    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action)
	    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename)
	  end },

        -- Autocompletion
        { "hrsh7th/nvim-cmp",
          dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "L3MON4D3/LuaSnip",
            "saadparwaiz1/cmp_luasnip",
          },
          config = function()
            local cmp = require("cmp")
            cmp.setup({
              snippet = { expand = function(args) require("luasnip").lsp_expand(args.body) end },
              mapping = cmp.mapping.preset.insert({
                ["<C-Space>"] = cmp.mapping.complete(),
                ["<CR>"]      = cmp.mapping.confirm({ select = true }),
                ["<Tab>"]     = cmp.mapping.select_next_item(),
                ["<S-Tab>"]   = cmp.mapping.select_prev_item(),
              }),
              sources = cmp.config.sources({
                { name = "nvim_lsp" }, { name = "luasnip" },
              }, { { name = "buffer" }, { name = "path" } }),
            })
          end },

        -- Git signs in gutter
        { "lewis6991/gitsigns.nvim", config = true },

        -- Status line
        { "nvim-lualine/lualine.nvim",
          dependencies = { "nvim-tree/nvim-web-devicons" },
          config = true },

        -- Auto pairs
        { "windwp/nvim-autopairs",
          event = "InsertEnter",
          config = true },

        -- Comment toggle
        { "numToStr/Comment.nvim", config = true },

        -- Rust extras
        { "mrcjkb/rustaceanvim", ft = "rust" },
      })
    '';
  };

  # ─────────────────────────────────────────────
  # GNOME settings via dconf
  # ─────────────────────────────────────────────
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme     = "prefer-dark";
      accent-color     = "purple";
      clock-show-date  = true;
      font-name        = "IBM Plex Sans 11";
      monospace-font-name = "IBM Plex Mono 11";
      show-battery-percentage = true;
      enable-animations = true;
    };
    
    "org/gnome/desktop/background" = {
      picture-uri       = "file:///home/rok/Pictures/wallpaper.jpg";
      picture-uri-dark  = "file:///home/rok/Pictures/wallpaper.jpg";
      picture-options   = "zoom";  # "zoom", "scaled", "centered", "stretched"
    };

    "org/gnome/desktop/wm/preferences" = {
      button-layout = "appmenu:minimize,close";
    };

    "org/gnome/desktop/peripherals/touchpad" = {
      tap-to-click     = true;
      two-finger-scrolling-enabled = true;
      natural-scroll   = true;
      speed            = 0.2;
    };

    "org/gnome/desktop/sound" = {
      event-sounds = false;   # disable click sounds
    };

    "org/gnome/shell" = {
      enabled-extensions = [
        "appindicatorsupport@rgcjonas.gmail.com"
        "blur-my-shell@aunetx"
      ];
    };

    # Power
    "org/gnome/settings-daemon/plugins/power" = {
      sleep-inactive-battery-timeout = 900;   # 15 min
      sleep-inactive-ac-timeout      = 3600;  # 1 hr
      power-button-action            = "suspend";
    };

    "org/gnome/desktop/screensaver" = {
      lock-delay = 0;
    };
    
    "org/gnome/settings-daemon/plugins/media-keys" = {
       custom-keybindings = [ "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/" ];
    };
    
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
      name = "Terminal";
      command = "/run/current-system/sw/bin/ghostty";
      binding = "<Alt><Ctrl>t";
    };
  };

  # ─────────────────────────────────────────────
  # XDG — default applications
  # ─────────────────────────────────────────────
  xdg = {
    enable = true;
    mimeApps = {
      enable = true;
      defaultApplications = {
        "text/html"               = "firefox.desktop";
        "x-scheme-handler/http"   = "firefox.desktop";
        "x-scheme-handler/https"  = "firefox.desktop";
        "application/pdf"         = "org.gnome.Evince.desktop";
        "image/png"               = "org.gnome.eog.desktop";
        "image/jpeg"              = "org.gnome.eog.desktop";
        "video/mp4"               = "vlc.desktop";
        "video/x-matroska"        = "vlc.desktop";
        "audio/mpeg"              = "vlc.desktop";
      };
    };
  };

  # ─────────────────────────────────────────────
  # Packages that only this user needs
  # (system-wide ones stay in configuration.nix)
  # ─────────────────────────────────────────────
  home.packages = with pkgs; [
    # CLI extras
    nix-tree       # visualise nix dependency tree
    nix-du         # disk usage of nix store
    duf            # pretty disk usage
    dust        # intuitive du
  ];
}
