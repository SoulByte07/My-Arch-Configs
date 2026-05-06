return {
  {
    "tpope/vim-fugitive",
    cmd = { "G", "Git" },
    config = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "fugitive",
        callback = function()
          vim.keymap.set("n", "a", "-", { remap = true, buffer = true, desc = "Stage/Unstage" })
          pcall(vim.keymap.del, "n", "-", { buffer = true })
        end,
      })
    end,
  },
  {
    "nvim-mini/mini.diff",
    version = false,
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      view = {
        style = "sign",
        signs = { add = "┃", change = "┃", delete = "_" },
      },
      delay = { text_change = 100 },
    },
    config = function(_, opts)
      local diff = require("mini.diff")
      diff.setup(opts)

      local function get_current_hunk_range()
        local line = vim.api.nvim_win_get_cursor(0)[1]
        local data = diff.get_buf_data(0)
        if not data or not data.hunks then
          return nil
        end

        for _, hunk in ipairs(data.hunks) do
          local start_line = math.max(hunk.buf_start, 1)
          local end_line = hunk.buf_count == 0 and start_line or (hunk.buf_start + hunk.buf_count - 1)
          if line >= start_line and line <= end_line then
            return start_line, end_line
          end
        end

        return nil
      end

      local function with_current_hunk(action, action_name)
        local start_line, end_line = get_current_hunk_range()
        if not start_line or not end_line then
          vim.notify("No hunk under cursor", vim.log.levels.WARN)
          return
        end

        diff.do_hunks(0, action, {
          line_start = start_line,
          line_end = end_line,
        })
        vim.notify(action_name .. " current hunk", vim.log.levels.INFO)
      end

      vim.keymap.set("n", "]c", function()
        if vim.wo.diff then
          return "]c"
        end
        diff.goto_hunk("next")
        return "<Ignore>"
      end, { expr = true, desc = "Next Hunk" })

      vim.keymap.set("n", "[c", function()
        if vim.wo.diff then
          return "[c"
        end
        diff.goto_hunk("prev")
        return "<Ignore>"
      end, { expr = true, desc = "Prev Hunk" })

      vim.keymap.set("n", "<leader>gs", function()
        with_current_hunk("apply", "Staged")
      end, { desc = "Stage Hunk" })

      vim.keymap.set("n", "<leader>gr", function()
        with_current_hunk("reset", "Reset")
      end, { desc = "Reset Hunk" })

      vim.keymap.set("n", "<leader>gp", function()
        diff.toggle_overlay(0)
      end, { desc = "Preview Hunk" })

      vim.keymap.set("n", "<leader>gb", "<cmd>Git blame<CR>", { desc = "Blame Line" })
    end,
  },
}
