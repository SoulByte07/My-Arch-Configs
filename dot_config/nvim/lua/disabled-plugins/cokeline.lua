-- File: lua/plugins/cokeline.lua

return {
	"willothy/nvim-cokeline",
	event = "VeryLazy",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons",
		"nvim-mini/mini.visits",
	},
	config = function()
		-- 1. HIGH-PERFORMANCE CACHE
		local pin_cache = {}
		local last_update = 0

		local function get_pins()
			local now = vim.uv.now()
			if now - last_update < 200 then
				return pin_cache
			end

			local visits = require("mini.visits")
			local cwd = vim.fn.getcwd()
			pin_cache = {}
			last_update = now

			for i = 1, 5 do
				local paths = visits.list_paths(cwd, {
					filter = function(p)
						return type(p.labels) == "table" and p.labels["harpoon_" .. i]
					end,
				})
				if paths[1] then
					pin_cache[paths[1]] = i
				end
			end

			return pin_cache
		end

		-- 2. CATPPUCCIN MOCHA COLORS
		local colors = {
			text_bg = "#313244", -- Surface 0
			text_fg = "#cdd6f4", -- Text
			active_bg = "#fab387", -- Peach
			inactive_bg = "#cba6f7", -- Blue
			number_fg = "#1e1e2e", -- Base
		}

		require("cokeline").setup({
			buffers = {
				-- 1. Your existing optimized filter
				filter_valid = function(buffer)
					local pins = get_pins()
					return pins[buffer.path] ~= nil
				end,

				-- 2. Dynamic ascending sorting logic
				new_buffers_position = function(a, b)
					local pins = get_pins()

					-- Extract slots, falling back to 99 if a file somehow bypasses the filter
					local slot_a = pins[a.path] or 99
					local slot_b = pins[b.path] or 99

					-- Sort ascending (1, 2, 3...)
					return slot_a < slot_b
				end,
			},

			-- 4. COMPONENT RENDERING
			components = {
				{ text = "  ", bg = "none" },
				{
					text = "",
					fg = colors.text_bg,
					bg = "none",
				},
				{
					-- Buffer Name
					text = function(buffer)
						return "" .. buffer.filename .. " "
					end,
					fg = colors.text_fg,
					bg = colors.text_bg,
				},
				{
					-- Mini.visits Slot Number
					text = function(buffer)
						local pins = get_pins()
						local slot = pins[buffer.path] or "?"
						return " " .. slot .. ""
					end,
					fg = colors.number_fg,
					bg = function(buffer)
						return buffer.is_focused and colors.active_bg or colors.inactive_bg
					end,
					bold = true,
				},
				{
					text = "",
					fg = function(buffer)
						return buffer.is_focused and colors.active_bg or colors.inactive_bg
					end,
					bg = "none",
				},
			},
		})

		-- 5. LOW-OVERHEAD STARTUP INJECTION
		vim.schedule(function()
			local visits = require("mini.visits")
			local cwd = vim.fn.getcwd()
			local bufadd = vim.fn.bufadd

			for i = 1, 5 do
				local paths = visits.list_paths(cwd, {
					filter = function(p)
						return type(p.labels) == "table" and p.labels["harpoon_" .. i]
					end,
				})

				local file = paths[1]
				if file and file ~= "" then
					local buf = bufadd(file)
					if not vim.bo[buf].buflisted then
						vim.bo[buf].buflisted = true
					end
				end
			end
		end)
	end,
}
