vim.g.base46_cache = vim.fn.stdpath "data" .. "/nvchad/base46/"
vim.g.mapleader = " "

-- bootstrap lazy and all plugins
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
  local repo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system { "git", "clone", "--filter=blob:none", repo, "--branch=stable", lazypath }
end

vim.opt.rtp:prepend(lazypath)

local lazy_config = require "configs.lazy"

-- load plugins
require("lazy").setup({
  {
    "NvChad/NvChad",
    lazy = false,
    branch = "v2.5",
    import = "nvchad.plugins",
    config = function()
      require "options"
    end,
  },

  { import = "plugins" },
}, lazy_config)

-- load theme
dofile(vim.g.base46_cache .. "defaults")
dofile(vim.g.base46_cache .. "statusline")
require("todo-comments").setup {
  keywords = {
    --FIX = { icon = " ", color = "error" },
    TODO = { icon = "󱑂 "},
    --HACK = { icon = " ", color = "warning" },
    --WARN = { icon = " ", color = "warning" },
    --PERF = { icon = " ", alt = { "OPTIMIZE" } },
    --NOTE = { icon = " ", color = "hint", alt = { "INFO" } },
    FINISH = { icon = " ", color = "#92DE5C" },  -- Add this line for FINISH
  },
  colors = {
    --error = { "LspDiagnosticsDefaultError", "ErrorMsg", "#DC2626" },
    --warning = { "LspDiagnosticsDefaultWarning", "WarningMsg", "#FBBF24" },
    --info = { "LspDiagnosticsDefaultInformation", "#2563EB" },
    --hint = { "LspDiagnosticsDefaultHint", "#10B981" },
    --default = { "Identifier", "#7C3AED" },
    green = { "String", "#92DE5C" },  -- Define the green color
  },
}
-- If you just want to ensure it's loaded (usually not necessary)
require('code_runner')
-- In your init.lua
vim.api.nvim_set_keymap('n', '<leader>a', ':RunCode<CR>', { noremap = true, silent = true })

require('ibl').setup{
	indent = {
		char = "┊",
	}
}

-- Define a custom command for formatting C files with c_formatter_42
vim.api.nvim_create_user_command('Format', function()
  -- Check if the current file is a C file
  local filetype = vim.bo.filetype
  if filetype == "c" then
    -- Run c_formatter_42 on the current file
    vim.cmd('!c_formatter_42 %')
  else
    print("Not a C file. This command only formats C files.")
  end
end, {})

require "nvchad.autocmds"
vim.schedule(function()
  require "mappings"
end)

