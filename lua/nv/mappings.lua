local utils = require("nv.utils")

local sections = {
  f = { desc = utils.get_icon("Search", 1, true) .. "Find" },
  p = { desc = utils.get_icon("Package", 1, true) .. "Packages" },
  l = { desc = utils.get_icon("ActiveLSP", 1, true) .. "LSP" },
  u = { desc = utils.get_icon("Window", 1, true) .. "UI/UX" },
  b = { desc = utils.get_icon("Tab", 1, true) .. "Buffers" },
  bs = { desc = utils.get_icon("Sort", 1, true) .. "Sort Buffers" },
  d = { desc = utils.get_icon("Debugger", 1, true) .. "Debugger" },
  g = { desc = utils.get_icon("Git", 1, true) .. "Git" },
  S = { desc = utils.get_icon("Session", 1, true) .. "Session" },
  t = { desc = utils.get_icon("Terminal", 1, true) .. "Terminal" },
}

local maps = utils.empty_map_table()

-- Standard Operations
maps.n["j"] = { "v:count == 0 ? 'gj' : 'j'", expr = true, desc = "Move cursor down" }
maps.n["k"] = { "v:count == 0 ? 'gk' : 'k'", expr = true, desc = "Move cursor up" }
maps.n["<Leader>w"] = { "<cmd>w<cr>", desc = "Save" }
maps.n["<Leader>q"] = { "<cmd>confirm q<cr>", desc = "Quit" }
maps.n["<Leader>n"] = { "<cmd>enew<cr>", desc = "New File" }
maps.n["|"] = { "<cmd>vsplit<cr>", desc = "Vertical Split" }
maps.n["\\"] = { "<cmd>split<cr>", desc = "Horizontal Split" }
maps.n["<C-s>"] = { "<cmd>w!<cr>", desc = "Force write" }
maps.n["<C-q>"] = { "<cmd>qa!<cr>", desc = "Force quit" }
maps.i["<C-s>"] = { "<C-o>:w<cr>", desc = "Save file" }
maps.i["<C-q>"] = { "<esc>", desc = "Exit insert mode" }

-- Plugin Manager
maps.n["<Leader>p"] = sections.p
maps.n["<Leader>pi"] = { require("lazy").install, desc = "Plugins Install" }
maps.n["<Leader>ps"] = { require("lazy").home, desc = "Plugins Status" }
maps.n["<Leader>pS"] = { require("lazy").sync, desc = "Plugins Sync" }
maps.n["<Leader>pu"] = { require("lazy").check, desc = "Plugins Check Updates" }
maps.n["<Leader>pU"] = { require("lazy").update, desc = "Plugins Update" }

-- Package Manager
maps.n["<Leader>pm"] = { "<cmd>Mason<cr>", desc = "Mason Installer" }
maps.n["<Leader>pM"] = { "<cmd>MasonUpdateAll<cr>", desc = "Mason Update" }

-- Manage Buffers
maps.n["<Leader>c"] = { require("nv.utils.buffer").close, desc = "Close buffer" }
maps.n["<Leader>C"] = { function() require("nv.utils.buffer").close(0, true) end, desc = "Force close buffer" }
maps.n["]b"] = {
  function() require("nv.utils.buffer").nav(vim.v.count > 0 and vim.v.count or 1) end,
  desc =
  "Next buffer"
}
maps.n["[b"] = {
  function() require("nv.utils.buffer").nav(-(vim.v.count > 0 and vim.v.count or 1)) end,
  desc =
  "Previous buffer"
}
maps.n[">b"] = {
  function() require("nv.utils.buffer").move(vim.v.count > 0 and vim.v.count or 1) end,
  desc =
  "Move buffer tab right"
}
maps.n["<b"] = {
  function() require("nv.utils.buffer").move(-(vim.v.count > 0 and vim.v.count or 1)) end,
  desc =
  "Move buffer tab left"
}

maps.n["<Leader>b"] = sections.b
maps.n["<Leader>bc"] = {
  function() require("nv.utils.buffer").close_all(true) end,
  desc =
  "Close all buffers except current"
}
maps.n["<Leader>bC"] = { require("nv.utils.buffer").close_all, desc = "Close all buffers" }
maps.n["<Leader>bl"] = { require("nv.utils.buffer").close_left, desc = "Close all buffers to the left" }
maps.n["<Leader>bp"] = { require("nv.utils.buffer").prev, desc = "Previous buffer" }
maps.n["<Leader>br"] = { require("nv.utils.buffer").close_right, desc = "Close all buffers to the right" }
maps.n["<Leader>bs"] = sections.bs
maps.n["<Leader>bse"] = { function() require("nv.utils.buffer").sort("extension") end, desc = "By extension" }
maps.n["<Leader>bsr"] = { function() require("nv.utils.buffer").sort("unique_path") end, desc = "By relative path" }
maps.n["<Leader>bsp"] = { function() require("nv.utils.buffer").sort("full_path") end, desc = "By full path" }
maps.n["<Leader>bsi"] = { function() require("nv.utils.buffer").sort("bufnr") end, desc = "By buffer number" }
maps.n["<Leader>bsm"] = { function() require("nv.utils.buffer").sort("modified") end, desc = "By modification" }

-- Manage Tabs
maps.n["<Leader>bb"] = {
  function()
    require("nv.utils.status.heirline").buffer_picker(function(bufnr) vim.api.nvim_win_set_buf(0, bufnr) end)
  end,
  desc = "Select buffer from tabline",
}
maps.n["<Leader>bd"] = {
  function()
    require("nv.utils.status.heirline").buffer_picker(function(bufnr) require("nv.utils.buffer").close(bufnr) end)
  end,
  desc = "Close buffer from tabline",
}
maps.n["<Leader>b\\"] = {
  function()
    require("nv.utils.status.heirline").buffer_picker(function(bufnr)
      vim.cmd.split()
      vim.api.nvim_win_set_buf(0, bufnr)
    end)
  end,
  desc = "Horizontal split buffer from tabline",
}
maps.n["<Leader>b|"] = {
  function()
    require("nv.utils.status.heirline").buffer_picker(function(bufnr)
      vim.cmd.vsplit()
      vim.api.nvim_win_set_buf(0, bufnr)
    end)
  end,
  desc = "Vertical split buffer from tabline",
}

-- Navigate tabs
maps.n["]t"] = { vim.cmd.tabnext, desc = "Next tab" }
maps.n["[t"] = { vim.cmd.tabprevious, desc = "Previous tab" }

-- Alpha
maps.n["<Leader>h"] = {
  function()
    local wins = vim.api.nvim_tabpage_list_wins(0)
    if #wins > 1 and vim.api.nvim_get_option_value("filetype", { win = wins[1] }) == "neo-tree" then
      vim.fn.win_gotoid(wins[2]) -- go to non-neo-tree window to toggle alpha
    end
    require("alpha").start(false, require("alpha").default_config)
  end,
  desc = "Home Screen",
}

-- Comment
maps.n["<Leader>/"] =
{
  function() require("Comment.api").toggle.linewise.count(vim.v.count > 0 and vim.v.count or 1) end,
  desc =
  "Toggle comment line"
}
maps.v["<Leader>/"] = {
  "<esc><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<cr>",
  desc =
  "Toggle comment for selection"
}

-- GitSigns
maps.n["<Leader>g"] = sections.g
maps.n["]g"] = { require("gitsigns").next_hunk, desc = "Next Git hunk" }
maps.n["[g"] = { require("gitsigns").prev_hunk, desc = "Previous Git hunk" }
maps.n["<Leader>gl"] = { require("gitsigns").blame_line, desc = "View Git blame" }
maps.n["<Leader>gL"] = { function() require("gitsigns").blame_line({ full = true }) end, desc = "View full Git blame" }
maps.n["<Leader>gp"] = { require("gitsigns").preview_hunk, desc = "Preview Git hunk" }
maps.n["<Leader>gh"] = { require("gitsigns").reset_hunk, desc = "Reset Git hunk" }
maps.n["<Leader>gr"] = { require("gitsigns").reset_buffer, desc = "Reset Git buffer" }
maps.n["<Leader>gs"] = { require("gitsigns").stage_hunk, desc = "Stage Git hunk" }
maps.n["<Leader>gS"] = { require("gitsigns").stage_buffer, desc = "Stage Git buffer" }
maps.n["<Leader>gu"] = { require("gitsigns").undo_stage_hunk, desc = "Unstage Git hunk" }
maps.n["<Leader>gd"] = { require("gitsigns").diffthis, desc = "View Git diff" }

-- NeoTree
maps.n["<Leader>e"] = { "<cmd>Neotree toggle<cr>", desc = "Toggle Explorer" }
maps.n["<Leader>o"] = {
  function()
    if vim.bo.filetype == "neo-tree" then
      vim.cmd.wincmd("p")
    else
      vim.cmd.Neotree("focus")
    end
  end,
  desc = "Toggle Explorer Focus",
}

-- Session Manager
maps.n["<Leader>S"] = sections.S
maps.n["<Leader>Sl"] = { function() require("resession").load("Last Session") end, desc = "Load last session" }
maps.n["<Leader>Ss"] = { require("resession").save, desc = "Save this session" }
maps.n["<Leader>St"] = { require("resession").save_tab, desc = "Save this tab's session" }
maps.n["<Leader>Sd"] = { require("resession").delete, desc = "Delete a session" }
maps.n["<Leader>Sf"] = { require("resession").load, desc = "Load a session" }
maps.n["<Leader>S."] = {
  function() require("resession").load(vim.fn.getcwd(), { dir = "dirsession" }) end,
  desc =
  "Load current directory session"
}

-- Smart Splits
maps.n["<C-h>"] = { require("smart-splits").move_cursor_left, desc = "Move to left split" }
maps.n["<C-j>"] = { require("smart-splits").move_cursor_down, desc = "Move to below split" }
maps.n["<C-k>"] = { require("smart-splits").move_cursor_up, desc = "Move to above split" }
maps.n["<C-l>"] = { require("smart-splits").move_cursor_right, desc = "Move to right split" }
maps.n["<C-Up>"] = { require("smart-splits").resize_up, desc = "Resize split up" }
maps.n["<C-Down>"] = { require("smart-splits").resize_down, desc = "Resize split down" }
maps.n["<C-Left>"] = { require("smart-splits").resize_left, desc = "Resize split left" }
maps.n["<C-Right>"] = { require("smart-splits").resize_right, desc = "Resize split right" }

-- SymbolsOutline
maps.n["<Leader>l"] = sections.l
maps.n["<Leader>lS"] = { require("aerial").toggle, desc = "Symbols outline" }

-- Telescope
maps.n["<Leader>f"] = sections.f
maps.n["<Leader>g"] = sections.g
maps.n["<Leader>gb"] = {
  function() require("telescope.builtin").git_branches({ use_file_path = true }) end,
  desc =
  "Git branches"
}
maps.n["<Leader>gc"] = {
  function() require("telescope.builtin").git_commits({ use_file_path = true }) end,
  desc =
  "Git commits (repository)"
}
maps.n["<Leader>gC"] = {
  function() require("telescope.builtin").git_bcommits({ use_file_path = true }) end,
  desc =
  "Git commits (current file)"
}
maps.n["<Leader>gt"] = {
  function() require("telescope.builtin").git_status({ use_file_path = true }) end,
  desc =
  "Git status"
}
maps.n["<Leader>f<CR>"] = { require("telescope.builtin").resume, desc = "Resume previous search" }
maps.n["<Leader>f'"] = { require("telescope.builtin").marks, desc = "Find marks" }
maps.n["<Leader>f/"] = { require("telescope.builtin").current_buffer_fuzzy_find, desc = "Find words in current buffer" }
maps.n["<Leader>fb"] = { require("telescope.builtin").buffers, desc = "Find buffers" }
maps.n["<leader>fd"] = {
  function() require("telescope.builtin").diagnostics({ bufnr = 0 }) end,
  desc =
  "Find diagnostics"
}
maps.n["<Leader>fc"] = { require("telescope.builtin").grep_string, desc = "Find word under cursor" }
maps.n["<Leader>fC"] = { require("telescope.builtin").commands, desc = "Find commands" }
maps.n["<Leader>ff"] = { require("telescope.builtin").find_files, desc = "Find files" }
maps.n["<Leader>fF"] = {
  function()
    require("telescope.builtin").find_files({
      hidden = true,
      no_ignore = true,
    })
  end,
  desc = "Find all files",
}
maps.n["<Leader>fh"] = { require("telescope.builtin").help_tags, desc = "Find help" }
maps.n["<Leader>fk"] = { require("telescope.builtin").keymaps, desc = "Find keymaps" }
maps.n["<Leader>fm"] = { require("telescope.builtin").man_pages, desc = "Find man" }
maps.n["<Leader>fn"] = { function() require("telescope").extensions.notify.notify() end, desc = "Find notifications" }
maps.n["<Leader>fo"] = { require("telescope.builtin").oldfiles, desc = "Find history" }
maps.n["<Leader>fr"] = { require("telescope.builtin").registers, desc = "Find registers" }
maps.n["<Leader>ft"] = {
  function() require("telescope.builtin").colorscheme({ enable_preview = true }) end,
  desc =
  "Find themes"
}
maps.n["<Leader>fw"] = { require("telescope.builtin").live_grep, desc = "Find words" }
maps.n["<Leader>fW"] = {
  function()
    require("telescope.builtin").live_grep({
      additional_args = function(args) return vim.list_extend(args, { "--hidden", "--no-ignore" }) end,
    })
  end,
  desc = "Find words in all files",
}
maps.n["<Leader>l"] = sections.l
maps.n["<Leader>ls"] = { require("telescope").extensions.aerial.aerial, desc = "Search symbols" }

-- Terminal
maps.n["<Leader>t"] = sections.t
maps.n["<Leader>tf"] = { "<cmd>ToggleTerm direction=float<cr>", desc = "ToggleTerm float" }
maps.n["<Leader>th"] = {
  "<cmd>ToggleTerm size=10 direction=horizontal<cr>",
  desc = "ToggleTerm horizontal split",
}
maps.n["<Leader>tv"] = {
  "<cmd>ToggleTerm size=80 direction=vertical<cr>",
  desc = "ToggleTerm vertical split",
}
maps.n["<F7>"] = { "<cmd>ToggleTerm<cr>", desc = "Toggle terminal" }
maps.t["<F7>"] = maps.n["<F7>"]
maps.n["<C-`>"] = maps.n["<F7>"] -- requires terminal that supports binding <C-'>
maps.t["<C-`>"] = maps.n["<F7>"] -- requires terminal that supports binding <C-'>
if vim.fn.executable("lazygit") == 1 then
  maps.n["<Leader>g"] = sections.g
  maps.n["<Leader>gg"] = {
    function()
      local worktree = require("nv.utils.git").file_worktree()
      local flags = worktree and (" --work-tree=%s --git-dir=%s"):format(worktree.toplevel, worktree.gitdir) or ""
      utils.toggle_term_cmd("lazygit " .. flags)
    end,
    desc = "ToggleTerm lazygit",
  }
  maps.n["<Leader>tl"] = maps.n["<leader>gg"]
end
if vim.fn.executable("node") == 1 then
  maps.n["<Leader>tn"] = {
    function() utils.toggle_term_cmd("node") end,
    desc =
    "ToggleTerm node"
  }
end
if vim.fn.executable("gdu") == 1 then
  maps.n["<Leader>tu"] = {
    function() utils.toggle_term_cmd("gdu") end,
    desc =
    "ToggleTerm gdu"
  }
end
if vim.fn.executable("btm") == 1 then
  maps.n["<Leader>tt"] = {
    function() utils.toggle_term_cmd("btm") end,
    desc =
    "ToggleTerm btm"
  }
end
local python = vim.fn.executable("python") == 1 and "python" or vim.fn.executable("python3") == 1 and "python3"
if python then
  maps.n["<Leader>tp"] = {
    function() utils.toggle_term_cmd(python) end,
    desc = "ToggleTerm python",
  }
end

-- Debugging
maps.n["<Leader>d"] = sections.d
maps.v["<Leader>d"] = sections.d
-- modified function keys found with `showkey -a` in the terminal to get key code
-- run `nvim -V3log +quit` and search through the "Terminal info" in the `log` file for the correct keyname
maps.n["<F5>"] = { require("dap").continue, desc = "Debugger: Start" }
maps.n["<F17>"] = { require("dap").terminate, desc = "Debugger: Stop" } -- Shift+F5
maps.n["<F21>"] = {                                                     -- Shift+F9
  function()
    vim.ui.input({ prompt = "Condition: " }, function(condition)
      if condition then require("dap").set_breakpoint(condition) end
    end)
  end,
  desc = "Debugger: Conditional Breakpoint",
}
maps.n["<F29>"] = { require("dap").restart_frame, desc = "Debugger: Restart" } -- Control+F5
maps.n["<F6>"] = { require("dap").pause, desc = "Debugger: Pause" }
maps.n["<F9>"] = { require("dap").toggle_breakpoint, desc = "Debugger: Toggle Breakpoint" }
maps.n["<F10>"] = { require("dap").step_over, desc = "Debugger: Step Over" }
maps.n["<F11>"] = { require("dap").step_into, desc = "Debugger: Step Into" }
maps.n["<F23>"] = { require("dap").step_out, desc = "Debugger: Step Out" } -- Shift+F11
maps.n["<Leader>db"] = { require("dap").toggle_breakpoint, desc = "Toggle Breakpoint (F9)" }
maps.n["<Leader>dB"] = { require("dap").clear_breakpoints, desc = "Clear Breakpoints" }
maps.n["<Leader>dc"] = { require("dap").continue, desc = "Start/Continue (F5)" }
maps.n["<Leader>dC"] = {
  function()
    vim.ui.input({ prompt = "Condition: " }, function(condition)
      if condition then require("dap").set_breakpoint(condition) end
    end)
  end,
  desc = "Conditional Breakpoint (S-F9)",
}
maps.n["<Leader>di"] = { require("dap").step_into, desc = "Step Into (F11)" }
maps.n["<Leader>do"] = { require("dap").step_over, desc = "Step Over (F10)" }
maps.n["<Leader>dO"] = { require("dap").step_out, desc = "Step Out (S-F11)" }
maps.n["<Leader>dq"] = { require("dap").close, desc = "Close Session" }
maps.n["<Leader>dQ"] = { require("dap").terminate, desc = "Terminate Session (S-F5)" }
maps.n["<Leader>dp"] = { require("dap").pause, desc = "Pause (F6)" }
maps.n["<Leader>dr"] = { require("dap").restart_frame, desc = "Restart (C-F5)" }
maps.n["<Leader>dR"] = { require("dap").repl.toggle, desc = "Toggle REPL" }
maps.n["<Leader>ds"] = { require("dap").run_to_cursor, desc = "Run To Cursor" }

maps.n["<Leader>dE"] = {
  function()
    vim.ui.input({ prompt = "Expression: " }, function(expr)
      if expr then require("dapui").eval(expr, { enter = true }) end
    end)
  end,
  desc = "Evaluate Input",
}
maps.v["<Leader>dE"] = { require("dapui").eval, desc = "Evaluate Input" }
maps.n["<Leader>du"] = { require("dapui").toggle, desc = "Toggle Debugger UI" }
maps.n["<Leader>dh"] = { require("dap.ui.widgets").hover, desc = "Debugger Hover" }

-- Improved Code Folding
maps.n["zR"] = { require("ufo").openAllFolds, desc = "Open all folds" }
maps.n["zM"] = { require("ufo").closeAllFolds, desc = "Close all folds" }
maps.n["zr"] = { require("ufo").openFoldsExceptKinds, desc = "Fold less" }
maps.n["zm"] = { require("ufo").closeFoldsWith, desc = "Fold more" }
maps.n["zp"] = { require("ufo").peekFoldedLinesUnderCursor, desc = "Peek fold" }

-- Stay in indent mode
maps.v["<S-Tab>"] = { "<gv", desc = "Unindent line" }
maps.v["<Tab>"] = { ">gv", desc = "Indent line" }

-- Improved Terminal Navigation
maps.t["<C-h>"] = { "<cmd>wincmd h<cr>", desc = "Terminal left window navigation" }
maps.t["<C-j>"] = { "<cmd>wincmd j<cr>", desc = "Terminal down window navigation" }
maps.t["<C-k>"] = { "<cmd>wincmd k<cr>", desc = "Terminal up window navigation" }
maps.t["<C-l>"] = { "<cmd>wincmd l<cr>", desc = "Terminal right window navigation" }

-- Custom menu for modification of the user experience
maps.n["<Leader>u"] = sections.u
maps.n["<Leader>ua"] = { require("nv.utils.ui").toggle_autopairs, desc = "Toggle autopairs" }
maps.n["<Leader>ub"] = { require("nv.utils.ui").toggle_background, desc = "Toggle background" }
maps.n["<Leader>uc"] = { require("nv.utils.ui").toggle_cmp, desc = "Toggle autocompletion" }
maps.n["<Leader>uC"] = { "<cmd>ColorizerToggle<cr>", desc = "Toggle color highlight" }
maps.n["<Leader>ud"] = { require("nv.utils.ui").toggle_diagnostics, desc = "Toggle diagnostics" }
maps.n["<Leader>ug"] = { require("nv.utils.ui").toggle_signcolumn, desc = "Toggle signcolumn" }
maps.n["<Leader>ui"] = { require("nv.utils.ui").set_indent, desc = "Change indent setting" }
maps.n["<Leader>ul"] = { require("nv.utils.ui").toggle_statusline, desc = "Toggle statusline" }
maps.n["<Leader>uL"] = { require("nv.utils.ui").toggle_codelens, desc = "Toggle CodeLens" }
maps.n["<Leader>un"] = { require("nv.utils.ui").change_number, desc = "Change line numbering" }
maps.n["<Leader>uN"] = { require("nv.utils.ui").toggle_notifications, desc = "Toggle Notifications" }
maps.n["<Leader>up"] = { require("nv.utils.ui").toggle_paste, desc = "Toggle paste mode" }
maps.n["<Leader>us"] = { require("nv.utils.ui").toggle_spell, desc = "Toggle spellcheck" }
maps.n["<Leader>uS"] = { require("nv.utils.ui").toggle_conceal, desc = "Toggle conceal" }
maps.n["<Leader>ut"] = { require("nv.utils.ui").toggle_tabline, desc = "Toggle tabline" }
maps.n["<Leader>uu"] = { require("nv.utils.ui").toggle_url_match, desc = "Toggle URL highlight" }
maps.n["<Leader>uw"] = { require("nv.utils.ui").toggle_wrap, desc = "Toggle wrap" }
maps.n["<Leader>uy"] = { require("nv.utils.ui").toggle_syntax, desc = "Toggle syntax highlighting (buffer)" }
maps.n["<Leader>uh"] = { require("nv.utils.ui").toggle_foldcolumn, desc = "Toggle foldcolumn" }

utils.set_mappings(maps)
