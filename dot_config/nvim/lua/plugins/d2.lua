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

          -- Helper function: Route output to Arch's RAM Disk (tmpfs)
          local function get_ram_output()
            return "/tmp/" .. vim.fn.expand("%:t:r") .. ".svg"
          end

          -- 1. The Save Hook (RAM-Disk Compiler)
          vim.api.nvim_create_autocmd("BufWritePost", {
            buffer = bufnr,
            callback = function()
              local file = vim.api.nvim_buf_get_name(bufnr)
              local output = get_ram_output()

              vim.fn.jobstart({ "d2", "fmt", file })
              vim.fn.jobstart({ "d2", file, output }) -- Writes to memory, not SSD
            end,
          })

          -- 2. The Viewer Launcher (Zombie Killer)
          vim.keymap.set("n", "<leader>dl", function()
            local file = vim.api.nvim_buf_get_name(bufnr)
            local output = get_ram_output()

            -- Force a synchronous compile first
            vim.fn.system({ "d2", file, output })

            -- If an imv window is already open, kill it cleanly
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
  {
    "ravsii/tree-sitter-d2",
    ft = "d2",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    build = "make nvim-install",
    config = function()
      require("nvim-treesitter.parsers").get_parser_configs().d2 = {
        install_info = {
          url = "https://github.com/ravsii/tree-sitter-d2",
          files = { "src/parser.c" },
          branch = "main",
        },
        filetype = "d2",
      }
    end,
  },
}
