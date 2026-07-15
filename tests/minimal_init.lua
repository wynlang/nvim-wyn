-- Minimal init that loads ONLY this plugin, for headless testing.
-- The repo root (two levels up from this file) is prepended to the runtimepath
-- so ftdetect/, ftplugin/, syntax/, and lua/ are all discovered as a normal
-- plugin would be, with no dependency on a plugin manager.
local here = debug.getinfo(1, "S").source:sub(2)
local repo = vim.fn.fnamemodify(here, ":p:h:h")
vim.opt.runtimepath:prepend(repo)
vim.opt.swapfile = false
vim.g.mapleader = " "
