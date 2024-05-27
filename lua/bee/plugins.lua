-- bootstrap Lazy
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-- Plugins
require("lazy").setup({
	-- Core --
	{ -- Useful lua functions used by lots of plugins
		"nvim-lua/plenary.nvim",
	},
	{ -- Allows plugins to use popups instead of splits
		"nvim-lua/popup.nvim",
	},
	{ -- Lua-based file explorer
		"nvim-tree/nvim-tree.lua",
	},
	{ -- Allows persistent and toggle-able terminals within nvim
		"akinsho/toggleterm.nvim",
		cmd = { "ToggleTerm" },
	},

	-- Bufferline --
	{ -- Adds a buffer line at top of nvim, emulates GUI IDEs
		"akinsho/bufferline.nvim",
	},
	{ -- Buffer Bye, it removes buffers intelligently and gives user options to do so as well
		"moll/vim-bbye",
	},

	-- Theme --
	{
		"EdenEast/nightfox.nvim",
		priority = 1000,
	},

	-- Statusline
	{
		"nvim-lualine/lualine.nvim",
		requires = { "nvim-tree/nvim-web-devicons", opt = true },
	},

	-- Characters
	{ -- Adds NerdFont devicon support to Vim for plugins like treesitter to use. Lua fork of Ryanoasis
		"nvim-tree/nvim-web-devicons",
	},

	-- Misc
	{ -- Auto indents lines, even blank ones
		"lukas-reineke/indent-blankline.nvim",
	},
	{ -- Smart commenting
		"numToStr/Comment.nvim",
	},
	-- { -- Companion to Comment plugin, sets code language based on context so you can use different comment styles within the same file, based on what's being commented
	-- 	"JoosepAlviste/nvim-ts-context-commentstring",
	-- },

	-- Telescope search --
	{ -- Telescope search
		"nvim-telescope/telescope.nvim",
	},
	{ -- Clipboard/Macro history, searchable with Telescope
		"AckslD/nvim-neoclip.lua",
		config = function()
			require("neoclip").setup()
		end,
	},

	-- Treesitter --
	{ -- better highlighting
		"nvim-treesitter/nvim-treesitter",
		run = ":TSUpdate",
	},

	-- Git --
	{ -- git decorations in nvim
		"lewis6991/gitsigns.nvim",
	},
})
