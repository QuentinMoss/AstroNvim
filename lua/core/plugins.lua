local M = {}

local packer_status_ok, packer = pcall(require, "packer")
if packer_status_ok then
  local utils = require "core.utils"
  local config = utils.user_settings()

  local astro_plugins = {
    -- Plugin manager
    {
      "wbthomason/packer.nvim",
    },

    -- Optimiser
    { "lewis6991/impatient.nvim" },

    -- Lua functions
    { "nvim-lua/plenary.nvim" },

    -- Popup API
    { "nvim-lua/popup.nvim" },

    -- Indent detection
    {
      "Darazaki/indent-o-matic",
      event = "BufRead",
      config = function()
        require("configs.indent-o-matic").config()
      end,
    },

    -- Notification Enhancer
    {
      "rcarriga/nvim-notify",
      config = function()
        require("configs.notify").config()
      end,
    },

    -- Neovim UI Enhancer
    {
      "MunifTanjim/nui.nvim",
      module = "nui",
    },

    -- Cursorhold fix
    {
      "antoinemadec/FixCursorHold.nvim",
      event = { "BufRead", "BufNewFile" },
      config = function()
        vim.g.cursorhold_updatetime = 100
      end,
    },

    -- Smarter Splits
    {
      "mrjones2014/smart-splits.nvim",
      module = "smart-splits",
      config = function()
        require("configs.smart-splits").config()
      end,
    },

    -- Icons
    {
      "kyazdani42/nvim-web-devicons",
      config = function()
        require("configs.icons").config()
      end,
    },

    -- Bufferline
    {
      "akinsho/bufferline.nvim",
      after = "nvim-web-devicons",
      config = function()
        require("configs.bufferline").config()
      end,
      disable = not config.enabled.bufferline,
    },

    -- Better buffer closing
    {
      "famiu/bufdelete.nvim",
      cmd = { "Bdelete", "Bwipeout" },
    },

    -- File explorer
    {
      "nvim-neo-tree/neo-tree.nvim",
      branch = "v2.x",
      module = "neo-tree",
      cmd = "Neotree",
      requires = "MunifTanjim/nui.nvim",
      config = function()
        require("configs.neo-tree").config()
      end,
      disable = not config.enabled.neo_tree,
    },

    -- Statusline
    {
      "nvim-lualine/lualine.nvim",
      config = function()
        require("configs.lualine").config()
      end,
      disable = not config.enabled.lualine,
    },

    -- Parenthesis highlighting
    {
      "p00f/nvim-ts-rainbow",
      after = "nvim-treesitter",
      disable = not config.enabled.ts_rainbow,
    },

    -- Autoclose tags
    {
      "windwp/nvim-ts-autotag",
      after = "nvim-treesitter",
      disable = not config.enabled.ts_autotag,
    },

    -- Context based commenting
    {
      "JoosepAlviste/nvim-ts-context-commentstring",
      after = "nvim-treesitter",
    },

    -- Syntax highlighting
    {
      "nvim-treesitter/nvim-treesitter",
      run = ":TSUpdate",
      event = { "BufRead", "BufNewFile" },
      cmd = {
        "TSInstall",
        "TSInstallInfo",
        "TSInstallSync",
        "TSUninstall",
        "TSUpdate",
        "TSUpdateSync",
        "TSDisableAll",
        "TSEnableAll",
      },
      config = function()
        require("configs.treesitter").config()
      end,
    },

    -- Snippet collection
    {
      "rafamadriz/friendly-snippets",
      after = "nvim-cmp",
    },

    -- Snippet engine
    {
      "L3MON4D3/LuaSnip",
      after = "friendly-snippets",
      config = function()
        require("configs.luasnip").config()
      end,
    },

    -- Completion engine
    {
      "hrsh7th/nvim-cmp",
      event = "InsertEnter",
      config = function()
        require("configs.cmp").config()
      end,
    },

    -- Snippet completion source
    {
      "saadparwaiz1/cmp_luasnip",
      after = "nvim-cmp",
      config = function()
        require("core.utils").add_user_cmp_source "luasnip"
      end,
    },

    -- Buffer completion source
    {
      "hrsh7th/cmp-buffer",
      after = "nvim-cmp",
      config = function()
        require("core.utils").add_user_cmp_source "buffer"
      end,
    },

    -- Path completion source
    {
      "hrsh7th/cmp-path",
      after = "nvim-cmp",
      config = function()
        require("core.utils").add_user_cmp_source "path"
      end,
    },

    -- LSP completion source
    {
      "hrsh7th/cmp-nvim-lsp",
      after = "nvim-cmp",
      config = function()
        require("core.utils").add_user_cmp_source "nvim_lsp"
      end,
    },

    -- Built-in LSP
    {
      "neovim/nvim-lspconfig",
      module = "lspconfig",
      opt = true,
      setup = function()
        require("core.utils").defer_plugin "nvim-lspconfig"
      end,
    },

    -- LSP manager
    {
      "williamboman/nvim-lsp-installer",
      after = "nvim-lspconfig",
      config = function()
        require("configs.nvim-lsp-installer").config()
        require "configs.lsp"
      end,
    },

    -- LSP symbols
    {
      "stevearc/aerial.nvim",
      module = "aerial",
      cmd = { "AerialToggle", "AerialOpen", "AerialInfo" },
      config = function()
        require("configs.aerial").config()
      end,
    },

    -- Formatting and linting
    {
      "jose-elias-alvarez/null-ls.nvim",
      event = { "BufRead", "BufNewFile" },
      config = function()
        local null_ls = require("core.utils").user_plugin_opts "null-ls"
        if type(null_ls) == "function" then
          null_ls()
        end
      end,
    },

    -- Fuzzy finder
    {
      "nvim-telescope/telescope.nvim",
      cmd = "Telescope",
      module = "telescope",
      config = function()
        require("configs.telescope").config()
      end,
    },

    -- Fuzzy finder syntax support
    {
      ("nvim-telescope/telescope-%s-native.nvim"):format(vim.fn.has "win32" == 1 and "fzy" or "fzf"),
      after = "telescope.nvim",
      run = "make",
      config = function()
        require("telescope").load_extension(vim.fn.has "win32" == 1 and "fzy_native" or "fzf")
      end,
    },

    -- Git integration
    {
      "lewis6991/gitsigns.nvim",
      opt = true,
      setup = function()
        require("core.utils").defer_plugin "gitsigns.nvim"
      end,
      config = function()
        require("configs.gitsigns").config()
      end,
      disable = not config.enabled.gitsigns,
    },

    -- Start screen
    {
      "goolord/alpha-nvim",
      config = function()
        require("configs.alpha").config()
      end,
    },

    -- Color highlighting
    {
      "norcalli/nvim-colorizer.lua",
      event = { "BufRead", "BufNewFile" },
      config = function()
        require("configs.colorizer").config()
      end,
      disable = not config.enabled.colorizer,
    },

    -- Autopairs
    {
      "windwp/nvim-autopairs",
      event = "InsertEnter",
      config = function()
        require("configs.autopairs").config()
      end,
    },

    -- Terminal
    {
      "akinsho/nvim-toggleterm.lua",
      cmd = "ToggleTerm",
      module = { "toggleterm", "toggleterm.terminal" },
      config = function()
        require("configs.toggleterm").config()
      end,
      disable = not config.enabled.toggle_term,
    },

    -- Commenting
    {
      "numToStr/Comment.nvim",
      event = { "BufRead", "BufNewFile" },
      config = function()
        require("configs.Comment").config()
      end,
      disable = not config.enabled.comment,
    },

    -- Indentation
    {
      "lukas-reineke/indent-blankline.nvim",
      config = function()
        require("configs.indent-line").config()
      end,
      disable = not config.enabled.indent_blankline,
    },

    -- Keymaps popup
    {
      "folke/which-key.nvim",
      module = { "which-key" },
      config = function()
        require("configs.which-key").config()
      end,
      disable = not config.enabled.which_key,
    },

    -- Smooth scrolling
    {
      "declancm/cinnamon.nvim",
      event = { "BufRead", "BufNewFile" },
      config = function()
        require("configs.cinnamon").config()
      end,
    },

    -- Smooth escaping
    {
      "max397574/better-escape.nvim",
      event = { "InsertEnter" },
      config = function()
        require("configs.better_escape").config()
      end,
    },

    -- Get extra JSON schemas
    { "b0o/SchemaStore.nvim" },

    -- Session manager
    {
      "Shatur/neovim-session-manager",
      module = "session_manager",
      cmd = "SessionManager",
      event = "BufWritePost",
      config = function()
        require("configs.session_manager").config()
      end,
    },
  }

  packer.startup {
    function(use)
      -- Load plugins!
      for _, plugin in
        pairs(
          require("core.utils").user_plugin_opts("plugins.init", require("core.utils").label_plugins(astro_plugins))
        )
      do
        use(plugin)
      end
    end,
    config = require("core.utils").user_plugin_opts("plugins.packer", {
      compile_path = vim.fn.stdpath "config" .. "/lua/packer_compiled.lua",
      display = {
        open_fn = function()
          return require("packer.util").float { border = "rounded" }
        end,
      },
      profile = {
        enable = true,
        threshold = 0.0001,
      },
      git = {
        clone_timeout = 300,
        subcommands = {
          update = "pull --rebase",
        },
      },
      auto_clean = true,
      compile_on_sync = true,
    }),
  }
end

return M
