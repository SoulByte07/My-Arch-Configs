-- file: mini-comment.lua (or equivalent in your lazy plugins directory)
return {
  "echasnovski/mini.comment",
  version = false,
  
  -- 1. Lazy load: The plugin only loads when 'cc' is pressed in normal or visual mode
  keys = {
    { "cc", mode = { "n", "v" }, desc = "Toggle Comment" },
  },
  
  -- 2. Configuration: Override default 'gc' bindings with 'cc'
  config = function()
    require("mini.comment").setup({
      mappings = {
        comment = "cc",        -- Toggle comment (e.g., ccip for inner paragraph)
        comment_line = "cc",   -- Toggle comment on current line
        comment_visual = "cc", -- Toggle comment on visual selection
        textobject = "cc",     -- Define 'comment' textobject
      },
    })
  end,
}
