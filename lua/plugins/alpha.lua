return {
  "goolord/alpha-nvim",
  cmd = "Alpha",
  opts = function()
    local dashboard = require("alpha.themes.dashboard")
    dashboard.section.header.val = {
      "     ╗W        ¢_    ",
      "   φ╣╣╣▓       ║╣▓,  ",
      " j╔└▓╣╣╣╣╦     ║╣╣╣▓ ",
      " ╠╠▒_╫╣╣╣╣▌    ║╣╣╣╣ ",
      " ╠╠╠╠╔╙╣╣╣╣▓╕  ║╣╣╣╣ ",
      " ╠╠╠╠╠  ╫╣╣╣╣▌ ║╣╣╣╣ ",
      " ╠╠╠╠╠   ╙╣╣╣╣▓╕╫╣╣╣ ",
      " ╠╠╠╠╠     ╣╣╣╣╣▄╙╣╣ ",
      " '╠╠╠╠      ╚╣╣╣╣▓┬╝ ",
      "   '╝╠       '▓╣╣╝   ",
      "     `         ╙     ",
    }
    dashboard.section.header.opts.hl = "DashboardHeader"
    dashboard.section.footer.opts.hl = "DashboardFooter"

    local button = require("nv.utils").alpha_button
    local get_icon = require("nv.utils").get_icon
    dashboard.section.buttons.val = {
      button("LDR n  ", get_icon("FileNew", 2, true) .. "New File  "),
      button("LDR f f", get_icon("Search", 2, true) .. "Find File  "),
      button("LDR f o", get_icon("DefaultFile", 2, true) .. "Recents  "),
      button("LDR f w", get_icon("WordFile", 2, true) .. "Find Word  "),
      button("LDR f '", get_icon("Bookmarks", 2, true) .. "Bookmarks  "),
      button("LDR S l", get_icon("Refresh", 2, true) .. "Last Session  "),
    }

    dashboard.config.layout = {
      { type = "padding", val = vim.fn.max({ 2, vim.fn.floor(vim.fn.winheight(0) * 0.2) }) },
      dashboard.section.header,
      { type = "padding", val = 5 },
      dashboard.section.buttons,
      { type = "padding", val = 3 },
      dashboard.section.footer,
    }
    dashboard.config.opts.noautocmd = true
    return dashboard
  end,
  config = function(_, opts)
    require("alpha").setup(opts.config)

    vim.api.nvim_create_autocmd("User", {
      pattern = "LazyVimStarted",
      desc = "Add Alpha dashboard footer",
      once = true,
      callback = function()
        local stats = require("lazy").stats()
        local ms = math.floor(stats.startuptime * 100 + 0.5) / 100
        opts.section.footer.val = { "neovim loaded " .. stats.count .. " plugins  in " .. ms .. "ms" }
        pcall(vim.cmd.AlphaRedraw)
      end,
    })
  end,
}
