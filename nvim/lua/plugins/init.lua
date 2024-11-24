return {
  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    lazy = false,
    version = false, -- set this if you want to always pull the latest change
    opts = {
      -- add any opts here
    },
    -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
    build = "make",
    -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      --- The below dependencies are optional,
      "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
      "zbirenbaum/copilot.lua",    -- for providers='copilot'
      {
        -- support for image pasting
        "HakonHarnes/img-clip.nvim",
        event = "VeryLazy",
        opts = {
          -- recommended settings
          default = {
            embed_image_as_base64 = false,
            prompt_for_file_name = false,
            drag_and_drop = {
              insert_mode = true,
            },
            -- required for Windows users
            use_absolute_path = true,
          },
        },
      },
      {
        -- Make sure to set this up properly if you have lazy=true
        'MeanderingProgrammer/render-markdown.nvim',
        opts = {
          file_types = { "markdown", "Avante" },
        },
        ft = { "markdown", "Avante" },
      },
    },
  },
  {
    "lvimuser/lsp-inlayhints.nvim",
    lazy = true,
  },
  {
    "CRAG666/code_runner.nvim",
    config = function()
      require("code_runner").setup {
        filetype = {
          c = function(...)
            -- Get the absolute path of the current file
            local dir = vim.fn.expand "%:p:h"
            local c_base = {
              "cd " .. dir .. " &&",               -- Change to the directory of the current file
              "make fclean && make &&",
            }

            -- Directly extract the NAME from the Makefile if defined
            local program_name =
                vim.fn.system "grep -oP '^NAME\\s*=\\s*.*' Makefile | grep -oP '(?<=\\=).*'"
            program_name = program_name:gsub("%s+", "")             -- Remove any trailing whitespace

            if program_name == "" then
              vim.notify("Program name not found", vim.log.levels.ERROR)
              return
            end

            vim.ui.input({ prompt = "Add more args:" }, function(input)
              -- Add the program name and input arguments to the command
              table.insert(c_base, "./" .. program_name .. " " .. input)
              local command = table.concat(c_base, " ")

              -- Open a floating terminal and send the command
              local term_id = require("nvchad.term").toggle { pos = "float", id = "floatTerm" }

              -- Wait for the terminal to open and then send the command
              vim.cmd "redraw"
              vim.defer_fn(function()
                local term_buf = vim.api.nvim_get_current_buf()
                local job_id = vim.b.terminal_job_id

                if job_id then
                  vim.api.nvim_chan_send(job_id, command .. "\n")
                else
                  vim.notify("Failed to send command to terminal", vim.log.levels.ERROR)
                end
              end, 100)               -- Adjust delay as needed
            end)
          end,
        },
      }
    end,
  },
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
    },
  },
  {
    "Isrothy/neominimap.nvim",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",       --- Recommended
    },
    enabled = false,
    lazy = false,                      -- NOTE: NO NEED to Lazy load
    init = function()
      vim.opt.wrap = false             -- Recommended
      vim.opt.sidescrolloff = 36       -- It's recommended to set a large value
      vim.g.neominimap = {
        auto_enable = true,
      }
    end,
  },
  {
    "folke/twilight.nvim",
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
    },
    config = function()
      require("twilight").setup {
        {
          dimming = {
            alpha = 0.25,             -- amount of dimming
            -- we try to get the foreground from the highlight groups or fallback color
            color = { "Normal", "#ffffff" },
            term_bg = "#000000",             -- if guibg=NONE, this will be used to calculate text color
            inactive = false,                -- when true, other windows will be fully dimmed (unless they contain the same buffer)
          },
          context = 10,                      -- amount of lines we will try to show around the current line
          treesitter = true,                 -- use treesitter when available for the filetype
          -- treesitter is used to automatically expand the visible text,
          -- but you can further control the types of nodes that should always be fully expanded
          expand = {           -- for treesitter, we we always try to expand to the top-most ancestor with these types
            "function",
            "method",
            "table",
            "if_statement",
          },
          exclude = {},           -- exclude these filetypes
        },
      }
    end,
  },
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
      -- add any options here
    },
    dependencies = {
      "MunifTanjim/nui.nvim",
      {
        "rcarriga/nvim-notify",
        opts = {
          icons = {
            DEBUG = " ",
            ERROR = " ",
            INFO = " ",
            TRACE = " ",
            WARN = " ",
          },
          level = 2,
          minimum_width = 50,
          render = "compact",
          stages = "fade_in_slide_out",
          time_formats = {
            notification = "%T",
            notification_history = "%FT%T",
          },
        },
        config = function()
          require("notify").setup {
            background_colour = "#000000",
          }
        end,
      },
    },
    config = function()
      require("noice").setup {
        lsp = {
          override = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
            ["vim.lsp.util.stylize_markdown"] = true,
            ["cmp.entry.get_documentation"] = true,             -- requires hrsh7th/nvim-cmp
          },
          hover = { enabled = false },
          signature = { enabled = false },
        },
        -- you can enable a preset for easier configuration
        presets = {
          bottom_search = false,                  -- use a classic bottom cmdline for search
          command_palette = true,                 -- position the cmdline and popupmenu together
          long_message_to_split = true,           -- long messages will be sent to a split
          inc_rename = true,                      -- enables an input dialog for inc-rename.nvim
          lsp_doc_border = true,                  -- add a border to hover docs and signature help
        },
        cmdline = {
          enabled = true,           -- enables the Noice cmdline UI
          view = "cmdline_popup",
          opts = {},                -- global options for the cmdline. See section on views
          format = {
            cmdline = { pattern = "^:", icon = " ", lang = "vim", title = " コマンドライン" },
            search_down = { kind = "search", pattern = "^/", icon = " ", lang = "regex" },
            search_up = { kind = "search", pattern = "^%?", icon = " ", lang = "regex" },
            filter = { pattern = "^:%s*!", icon = "$", lang = "bash" },
            lua = {
              pattern = { "^:%s*lua%s+", "^:%s*lua%s*=%s*", "^:%s*=%s*" },
              icon = "",
              lang = "lua",
            },
            help = { pattern = "^:%s*he?l?p?%s+", icon = "" },
            input = {},             -- Used by input()
            -- lua = false, -- to disable a format, set to `false`
          },
        },
        views = {
          cmdline_popup = {
            position = {
              row = 24,
              col = "50%",
            },
            size = {
              width = 60,
              height = "auto",
            },
          },
          popupmenu = {
            --relative = "editor",
            position = {
              row = 60,
              col = "50%",
            },
            size = {
              width = 60,
              height = "auto",
            },
            border = {
              style = "Normal",
              padding = { 0, 1 },
            },
            win_options = {
              winhighlight = { Normal = "Normal", FloatBorder = "DiagnosticInfo" },
            },
          },
        },
      }
    end,
  },
  {
    "stevearc/conform.nvim",
    -- event = 'BufWritePre', -- uncomment for format on save
    opts = require "configs.conform",
  },

  -- These are some examples, uncomment them if you want to see them work!
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "vim",
        "lua",
        "vimdoc",
        "html",
        "css",
      },
    },
  },
  {
    "Diogo-ss/42-header.nvim",
    cmd = { "Stdheader" },
    keys = { "<F1>" },
    opts = {
      default_map = true,                                -- Default mapping <F1> in normal mode.
      auto_update = true,                                -- Update header when saving.
      user = "ferafano",                                 -- Your user.
      mail = "ferafano@student.42antananarivo.mg",       -- Your mail.
      -- add other options.
    },
    config = function(_, opts)
      require("42header").setup(opts)
    end,
  },
}
