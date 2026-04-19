-- File: ~/.config/nvim/lua/plugins/spider.lua
return {
	"chrisgrieser/nvim-spider",
	keys = {
		{
			"w",
			"<cmd>lua require('spider').motion('w')<cr>",
			mode = { "n", "o", "x" },
			desc = "Spider-w",
		},
		{
			"e",
			"<cmd>lua require('spider').motion('e')<cr>",
			mode = { "n", "o", "x" },
			desc = "Spider-e",
		},
		{
			"b",
			"<cmd>lua require('spider').motion('b')<cr>",
			mode = { "n", "o", "x" },
			desc = "Spider-b",
		},
	},
	opts = {
		skipInsignificantPunctuation = true,
		consistentOperatorPending = true, 
	},
}
