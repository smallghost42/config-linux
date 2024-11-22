require "nvchad.mappings"

local map = vim.keymap.set

-- Custom mappings
map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

-- Save in normal, insert, and visual modes
map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")

-- Add mappings for 'menu' plugin

-- Keyboard users - opens the default menu with Ctrl-t
map("n", "<C-t>", function()
  require("menu").open("default")
end, { desc = "Open default menu" })

-- Mouse users + NvimTree users - opens contextual menu with right-click
map("n", "<RightMouse>", function()
  vim.cmd.exec '"normal! \\<RightMouse>"'
  local options = vim.bo.ft == "NvimTree" and "nvimtree" or "default"
  require("menu").open(options, { mouse = true })
end, { desc = "Open contextual menu" })

