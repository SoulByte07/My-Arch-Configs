-- In your plugins/d2.lua

return {
  {
    "terrastruct/d2-vim",
    ft = "d2",
    init = function()
      local imv_job_id = nil

      vim.api.nvim_create_autocmd("FileType", {
        pattern = "d2",
        callback = function(event)
          local bufnr = event.buf

          local function get_ram_output()
            return "/tmp/" .. vim.fn.expand("%:t:r") .. ".svg"
          end

          -- 1. The Save Hook (RAM-Disk Compiler)
          vim.api.nvim_create_autocmd("BufWritePost", {
            buffer = bufnr,
            callback = function()
              local file = vim.api.nvim_buf_get_name(bufnr)
              local output = get_ram_output()

              -- Format and compile silently in the background
              vim.fn.jobstart({ "d2", "fmt", file })
              vim.fn.jobstart({ "d2", file, output }) -- Writes to memory, not SSD
            end,
          })

          -- 2. The Viewer Launcher (Zombie Killer)
          vim.keymap.set("n", "<leader>dl", function()
            local file = vim.api.nvim_buf_get_name(bufnr)
            local output = get_ram_output()

            -- Force a synchronous compile first to ensure the file exists
            vim.fn.system({ "d2", file, output })

            -- If an imv window is already open, kill it cleanly to prevent zombies
            if imv_job_id ~= nil then
              vim.fn.jobstop(imv_job_id)
            end

            -- Launch the viewer and store its process ID
            imv_job_id = vim.fn.jobstart({ "imv", output })

            print("D2 RAM-Preview Active: " .. output)
          end, { desc = "Start D2 Live Preview", buffer = bufnr })
        end,
      })
    end,
  },
}
