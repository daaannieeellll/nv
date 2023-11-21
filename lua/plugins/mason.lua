return {
  {
    "williamboman/mason.nvim",
    cmd = {
      "Mason",
      "MasonInstall",
      "MasonUninstall",
      "MasonUninstallAll",
      "MasonLog",
      "MasonUpdate",
      "MasonUpdateAll",
    },
    opts = {
      ui = {
        icons = {
          package_installed = "✓",
          package_uninstalled = "✗",
          package_pending = "⟳",
        },
      },
    },
    build = ":MasonUpdate",
    config = function(_, opts)
      require("mason").setup(opts)

      -- TODO: change these auto command names to not conflict with core Mason commands
      local cmd = vim.api.nvim_create_user_command
      cmd("MasonUpdate", function(options) require("nv.utils.mason").update(options.fargs) end, {
        nargs = "*",
        desc = "Update Mason Package",
        complete = function(arg_lead)
          local _ = require("mason-core.functional")
          return _.sort_by(_.identity,
            _.filter(_.starts_with(arg_lead), require("mason-registry").get_installed_package_names()))
        end,
      })
      cmd("MasonUpdateAll", require("nv.utils.mason").update_all, { desc = "Update Mason Packages" })

      for _, plugin in ipairs({ "mason-lspconfig", "mason-null-ls", "mason-nvim-dap" }) do
        pcall(require, plugin)
      end
    end,
  },
}
