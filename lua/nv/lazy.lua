--- ### Lazy
--
-- Sets up lazy package manager and loads plugins.
--
-- @module lazy
-- @copyright 2022
-- @license GNU General Public License v3.0

local git_version = vim.fn.system({ "git", "--version" })
if vim.api.nvim_get_vvar("shell_error") ~= 0 then vim.api.nvim_err_writeln("Git doesn't appear to be available...\n\n" ..
  git_version) end
local major, min, _ = unpack(vim.tbl_map(tonumber, vim.split(git_version:match("%d+%.%d+%.%d"), "%.")))
local modern_git = major > 2 or (major == 2 and min >= 19)

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
-- if lazy.nvim isn't installed, clone it
if not (vim.uv or vim.loop).fs_stat(lazypath) then -- TODO: REMOVE vim.loop WHEN DROPPING SUPPORT FOR Neovim v0.9
  local clone = { "git", "clone", modern_git and "--filter=blob:none" or nil }
  local output = vim.fn.system(vim.list_extend(clone,
    { "--branch=stable", "https://github.com/folke/lazy.nvim.git", lazypath }))
  if vim.api.nvim_get_vvar("shell_error") ~= 0 then vim.api.nvim_err_writeln("Error cloning lazy.nvim repository...\n\n" ..
    output) end
  local oldcmdheight = vim.opt.cmdheight:get()
  vim.opt.cmdheight = 1
  vim.notify("Please wait while plugins are installed...")
  vim.api.nvim_create_autocmd("User", {
    desc = "Load Mason and Treesitter after Lazy installs plugins",
    once = true,
    pattern = "LazyInstall",
    callback = function()
      vim.cmd.bw()
      vim.opt.cmdheight = oldcmdheight
      vim.tbl_map(function(module) pcall(require, module) end, { "nvim-treesitter", "mason" })
      require("nv.utils").notify("Mason is installing packages if configured, check status with `:Mason`")
    end,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec = { { import = "lazy_snapshot" }, { import = "plugins" } },
  defaults = { lazy = true },
  git = { filter = modern_git },
  install = { colorscheme = { nv.colorscheme } },
  performance = {
    rtp = {
      paths = { nv.install.home },
      disabled_plugins = { "tohtml", "gzip", "matchit", "zipPlugin", "netrwPlugin", "tarPlugin" },
    },
  },
  lockfile = vim.fn.stdpath("data") .. "/lazy-lock.json",
})
