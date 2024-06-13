return {
	{ -- Rose Pine colorscheme
		"rose-pine/neovim",
		name = "rose-pine",
		config = function()
			require("rose-pine").setup({
				disable_background = false,
				variant = "moon",
				dark_variant = "main",
				dim_inactive_windows = false,

				enable = {
					terminal = true,
					legacy_highlights = false,
					migrations = false,
				},

				styles = {
					bold = true,
					italic = true,
					transparency = true,
				},
			})

			vim.cmd("colorscheme rose-pine")
		end,
	},

	{ -- Statusline
		"nvim-lualine/lualine.nvim",
		event = "ColorScheme",
		dependencies = { "nvim-tree/nvim-web-devicons", opt = true },
		priority = 1000,
		config = function()
			require("lualine").setup({
				options = {
					--- @usage 'rose-pine' | 'rose-pine-alt'
					theme = "rose-pine",
				},
			})
		end,
	},

	{ -- Bufferline
		"akinsho/bufferline.nvim",
		event = "ColorScheme",
		config = function()
			local highlights = require("rose-pine.plugins.bufferline")
			require("bufferline").setup({ highlights = highlights })
		end,
	},
}
