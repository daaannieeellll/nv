return {
  "b0o/SchemaStore.nvim",
  {
    "folke/neodev.nvim",
    opts = {
      override = function(root_dir, library)
        library.plugins = root_dir:match(nv.install.home)
        vim.b.neodev_enabled = library.enabled
      end,
    },
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      {
        "folke/neoconf.nvim",
        opts = function()
          local global_settings
          local dir, depth = vim.fn.stdpath("config"):gsub("/", "")
          dir = dir .. "/lua/user"
          if vim.fn.isdirectory(dir) == 1 then
            local path = dir .. "/neoconf.json"
            if vim.fn.filereadable(path) == 1 then global_settings = path end
          end
          return { global_settings = global_settings and string.rep("../", depth):sub(1, -2) .. global_settings }
        end,
      },
      {
        "williamboman/mason-lspconfig.nvim",
        cmd = { "LspInstall", "LspUninstall" },
        opts = function(_, opts)
          if not opts.handlers then opts.handlers = {} end
          opts.handlers[1] = function(server) require("nv.utils.lsp").setup(server) end
        end,
        config = function(_, opts)
          require("mason-lspconfig").setup(opts)
          require("nv.utils").event("MasonLspSetup")
        end,
      },
    },
    cmd = function(_, cmds) -- HACK: lazy load lspconfig on `:Neoconf` if neoconf is available
      if require("nv.utils").is_available("neoconf.nvim") then table.insert(cmds, "Neoconf") end
    end,
    event = "User NVFile",
    config = function(_, _)
      local lsp = require("nv.utils.lsp")
      local utils = require("nv.utils")
      local get_icon = utils.get_icon
      local signs = {
        { name = "DiagnosticSignError",    text = get_icon("DiagnosticError"),        texthl = "DiagnosticSignError" },
        { name = "DiagnosticSignWarn",     text = get_icon("DiagnosticWarn"),         texthl = "DiagnosticSignWarn" },
        { name = "DiagnosticSignHint",     text = get_icon("DiagnosticHint"),         texthl = "DiagnosticSignHint" },
        { name = "DiagnosticSignInfo",     text = get_icon("DiagnosticInfo"),         texthl = "DiagnosticSignInfo" },
        { name = "DapStopped",             text = get_icon("DapStopped"),             texthl = "DiagnosticWarn" },
        { name = "DapBreakpoint",          text = get_icon("DapBreakpoint"),          texthl = "DiagnosticInfo" },
        { name = "DapBreakpointRejected",  text = get_icon("DapBreakpointRejected"),  texthl = "DiagnosticError" },
        { name = "DapBreakpointCondition", text = get_icon("DapBreakpointCondition"), texthl = "DiagnosticInfo" },
        { name = "DapLogPoint",            text = get_icon("DapLogPoint"),            texthl = "DiagnosticInfo" },
      }

      for _, sign in ipairs(signs) do
        vim.fn.sign_define(sign.name, sign)
      end
      lsp.setup_diagnostics(signs)

      local orig_handler = vim.lsp.handlers["$/progress"]
      vim.lsp.handlers["$/progress"] = function(_, msg, info)
        local progress, id = nv.lsp.progress, ("%s.%s"):format(info.client_id, msg.token)
        progress[id] = progress[id] and utils.extend_tbl(progress[id], msg.value) or msg.value
        if progress[id].kind == "end" then
          vim.defer_fn(function()
            progress[id] = nil
            utils.event("LspProgress")
          end, 100)
        end
        utils.event("LspProgress")
        orig_handler(_, msg, info)
      end

      if vim.g.lsp_handlers_enabled then
        vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover,
          { border = "rounded", silent = true })
        vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help,
          { border = "rounded", silent = true })
      end
      local setup_servers = function()
        vim.tbl_map(require("nv.utils.lsp").setup, nv.user_opts("lsp.servers"))
        vim.api.nvim_exec_autocmds("FileType", {})
        require("nv.utils").event("LspSetup")
      end
      if require("nv.utils").is_available("mason-lspconfig.nvim") then
        vim.api.nvim_create_autocmd("User", {
          desc = "set up LSP servers after mason-lspconfig",
          pattern = "NVMasonLspSetup",
          once = true,
          callback = setup_servers,
        })
      else
        setup_servers()
      end
    end,
  },
  {
    "nvimtools/none-ls.nvim",
    dependencies = {
      {
        "jay-babu/mason-null-ls.nvim",
        cmd = { "NullLsInstall", "NullLsUninstall" },
        opts = { handlers = {} },
      },
    },
    event = "User NVFile",
    opts = function() return { on_attach = require("nv.utils.lsp").on_attach } end,
  },
  {
    "stevearc/aerial.nvim",
    event = "User NVFile",
    opts = {
      attach_mode = "global",
      backends = { "lsp", "treesitter", "markdown", "man" },
      disable_max_lines = vim.g.max_file.lines,
      disable_max_size = vim.g.max_file.size,
      layout = { min_width = 28 },
      show_guides = true,
      filter_kind = false,
      guides = {
        mid_item = "├ ",
        last_item = "└ ",
        nested_top = "│ ",
        whitespace = "  ",
      },
      keymaps = {
        ["[y"] = "actions.prev",
        ["]y"] = "actions.next",
        ["[Y"] = "actions.prev_up",
        ["]Y"] = "actions.next_up",
        ["{"] = false,
        ["}"] = false,
        ["[["] = false,
        ["]]"] = false,
      },
    },
  },
}
