local function loadModule(module)
  local status_ok, fault = pcall(require, "nv." .. module)
  if not status_ok then vim.api.nvim_err_writeln("Failed to load " .. module .. "\n\n" .. fault) end
end

local modules = { "bootstrap", "options", "lazy", "autocmds", "mappings" }
vim.tbl_map(loadModule, modules)

if nv.colorscheme then
  if not pcall(vim.cmd.colorscheme, nv.colorscheme) then
    require("nv.utils").notify("Error setting up colorscheme: " .. nv.colorscheme, vim.log.levels.ERROR)
  end
end
