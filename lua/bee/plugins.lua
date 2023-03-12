local fn = vim.fn

-- Automatically install packer
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
	PACKER_BOOTSTRAP = fn.system({
		"git",
		"clone",
		"--depth",
		"1",
		"https://github.com/wbthomason/packer.nvim",
		install_path,
	})
	print("Installing packer, close and reopen Neovim...")
	vim.cmd([[packadd packer.nvim]])
end

-- Reload neovim whenever you save the plugins.lua file
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]])

-- Use protected call to avoid error on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
	print("Packer not found")
	return
end

-- Have packer use a floating window
packer.init({
	display = {
		open_fn = function()
			return require("packer.util").float({ border = "rounded" })
		end,
	},
})

-- Plugins
return packer.startup(function(use)
	-- Core --
	use({ -- Have packer manage itself
		"wbthomason/packer.nvim",
		commit = "1d0cf98a561f7fd654c970c49f917d74fafe1530",
	})
	use({ -- Useful lua functions used by lots of plugins
		"nvim-lua/plenary.nvim",
		commit = "253d34830709d690f013daf2853a9d21ad7accab",
	})
	use({ -- Allows plugins to use popups instead of splits
		"nvim-lua/popup.nvim",
		commit = "b7404d35d5d3548a82149238289fa71f7f6de4ac",
	})
	--[[ use({          -- Keybind helper for commands you're typing ]]
	--[[   "folke/which-key.nvim", ]]
	--[[   commit = "61553aeb3d5ca8c11eea8be6eadf478062982ac9", ]]
	--[[ }) ]]
	use({ -- Lua-based file explorer
		"nvim-tree/nvim-tree.lua",
		commit = "bbb6d4891009de7dab05ad8fc2d39f272d7a751c",
	})
	use({ -- Allows persistent and toggle-able terminals within nvim
		"akinsho/toggleterm.nvim",
		commit = "c8e982ad2739eeb0b13d0fecb14820c9bf5e3da0",
	})
	-- use({ "lewis6991/impatient.nvim" }) -- Speeds up loading nvim lua modules
	-- use({ "goolord/alpha-nvim" }) -- Greeter for nvim

	-- Bufferline --
	use({ -- Adds a buffer line at top of nvim, emulates GUI IDEs
		"akinsho/bufferline.nvim",
		commit = "3677aceb9a72630b0613e56516c8f7151b86f95c",
	})
	use({ -- "Buffer Bye", it removes buffers intelligently and gives user options to do so as well
		"moll/vim-bbye",
		commit = "25ef93ac5a87526111f43e5110675032dbcacf56",
	})

	-- Theme --
	use({
		"EdenEast/nightfox.nvim",
		commit = "a8044b084e0114609ec2c59cc4fa94c709a457d4",
	})

	-- Statusline
	use({
		"feline-nvim/feline.nvim",
		commit = "d48b6f92c6ccdd6654c956f437be49ea160b5b0c",
	})

	-- Characters
	use({ -- Adds NerdFont devicon support to Vim for plugins like treesitter to use. Lua fork of Ryanoasis
		"kyazdani42/nvim-web-devicons",
		commit = "4af94fec29f508159ceab5413383e5dedd6c24e3",
	})

	-- Markdown Previewer --
	use({
		"iamcco/markdown-preview.nvim",
		run = function()
			vim.fn["mkdp#util#install"]()
		end,
		commit = "02cc3874738bc0f86e4b91f09b8a0ac88aef8e96",
	})
	-- Completions and Linting --
	-- Cmp
	use({ -- The completion plugin
		"hrsh7th/nvim-cmp",
		commit = "feed47fd1da7a1bad2c7dca456ea19c8a5a9823a",
	})
	use({ -- buffer completions
		"hrsh7th/cmp-buffer",
		commit = "3022dbc9166796b644a841a02de8dd1cc1d311fa",
	})
	use({ -- path completions
		"hrsh7th/cmp-path",
		commit = "91ff86cd9c29299a64f968ebb45846c485725f23",
	})
	use({ -- cmdline completions
		"hrsh7th/cmp-cmdline",
		commit = "8fcc934a52af96120fe26358985c10c035984b53",
	})
	use({ -- snippet completions
		"saadparwaiz1/cmp_luasnip",
		commit = "18095520391186d634a0045dacaa346291096566",
	})
	use({ -- Autopairs, integrates with both cmp and treesitter
		"windwp/nvim-autopairs",
		commit = "e755f366721bc9e189ddecd39554559045ac0a18",
	})

	-- Snippets
	use({ --snippet engine
		"L3MON4D3/LuaSnip",
		commit = "436857749a905b48c1e8205b996639c28f006556",
	})
	use({ -- a bunch of snippets to use
		"rafamadriz/friendly-snippets",
		commit = "2f5b8a41659a19bd602497a35da8d81f1e88f6d9",
	})
	use({ -- for formatters and linters
		"jose-elias-alvarez/null-ls.nvim",
		commit = "09e99259f4cdd929e7fb5487bf9d92426ccf7cc1",
	})
	use({ -- Highlights other uses of word for LSP
		"RRethy/vim-illuminate",
		commit = "49062ab1dd8fec91833a69f0a1344223dd59d643",
	})

	-- Misc
	use({ -- Auto indents lines, even blank ones
		"lukas-reineke/indent-blankline.nvim",
		commit = "018bd04d80c9a73d399c1061fa0c3b14a7614399",
	})
	use({ -- Smart commenting
		"numToStr/Comment.nvim",
		commit = "8d3aa5c22c2d45e788c7a5fe13ad77368b783c20",
	})
	use({ -- Companion to Comment plugin, sets code language based on context so you can use different comment styles within the same file, based on what's being commented
		"JoosepAlviste/nvim-ts-context-commentstring",
		commit = "729d83ecb990dc2b30272833c213cc6d49ed5214",
	})

	-- Telescope search --
	use({ -- Telescope search
		"nvim-telescope/telescope.nvim",
		commit = "a3f17d3baf70df58b9d3544ea30abe52a7a832c2",
	})
	use({ -- Clipboard/Macro history, searchable with Telescope
		"AckslD/nvim-neoclip.lua",
		config = function()
			require("neoclip").setup()
		end,
		commit = "5b9286a40ea2020352280caeb713515badb03d99",
	})

	-- Treesitter --
	use({ -- better highlighting
		"nvim-treesitter/nvim-treesitter",
		run = ":TSUpdate",
		commit = "e3ebc8ec5d586162f3c408417621daa59ba8ea62",
	})
	use({ -- Rainbow parentheses for treesitter
		"p00f/nvim-ts-rainbow",
		commit = "ef95c15a935f97c65a80e48e12fe72d49aacf9b9",
	})

	-- Git --
	use({ -- git decorations in nvim
		"lewis6991/gitsigns.nvim",
		commit = "b1f9cf7c5c5639c006c937fc1819e09f358210fc",
	})
	-- Automatically set up your configuration after cloning packer.nvim
	if PACKER_BOOTSTRAP then
		require("packer").sync()
	end
end)
