return {
	"nvim-treesitter/nvim-treesitter",
	branch = "master",
	lazy = false,
	build = ":TSUpdate",
	config = function()
		local configs = require("nvim-treesitter.configs")
		configs.setup({
			ensure_installed = { "lua", "markdown", "go", "javascript", "php", "vue" },
			highlight = { enable = true },
			indent = { enable = true },
		})
	end,
}
