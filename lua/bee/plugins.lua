local fn = vim.fn

-- Automatically install packer
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
	PACKER_BOOTSTRAP = fn.system({
		"git",
		"clone",
		"--depth",
		"1",
		"wbthomason/packer.nvim",
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
		commit = "ea0cc3c59f67c440c5ff0bbe4fb9420f4350b9a3",
	})
	use({ -- Useful lua functions used by lots of plugins
		"nvim-lua/plenary.nvim",
		commit = "50012918b2fc8357b87cff2a7f7f0446e47da174",
	})
	use({ -- Allows plugins to use popups instead of splits
		"nvim-lua/popup.nvim",
		commit = "b7404d35d5d3548a82149238289fa71f7f6de4ac",
	})
	use({ -- Lua-based file explorer
		"nvim-tree/nvim-tree.lua",
		commit = "80cfeadf179d5cba76f0f502c71dbcff1b515cd8",
	})
	use({ -- Allows persistent and toggle-able terminals within nvim
		"akinsho/toggleterm.nvim",
		commit = "c80844fd52ba76f48fabf83e2b9f9b93273f418d",
	})

	-- Bufferline --
	use({ -- Adds a buffer line at top of nvim, emulates GUI IDEs
		"akinsho/bufferline.nvim",
		commit = "9e8d2f695dd50ab6821a6a53a840c32d2067a78a",
	})
	use({ -- Buffer Bye, it removes buffers intelligently and gives user options to do so as well
		"moll/vim-bbye",
		commit = "25ef93ac5a87526111f43e5110675032dbcacf56",
	})

	-- Theme --
	use({
		"EdenEast/nightfox.nvim",
		commit = "6a6076bd678f825ffbe16ec97807793c3167f1a7",
	})

	-- Statusline
	use({
		"freddiehaddad/feline.nvim",
		commit = "62a9f4fd4fcf46cb87b7868323a1e9aef5b08028",
	})

	-- Characters
	use({ -- Adds NerdFont devicon support to Vim for plugins like treesitter to use. Lua fork of Ryanoasis
		"nvim-tree/nvim-web-devicons",
		commit = "3523d6e6d40ab11fd66c1b2732b3d6b60affa951",
	})

	-- Misc
	use({ -- Auto indents lines, even blank ones
		"lukas-reineke/indent-blankline.nvim",
		commit = "29be0919b91fb59eca9e90690d76014233392bef",
	})
	use({ -- Smart commenting
		"numToStr/Comment.nvim",
		commit = "0236521ea582747b58869cb72f70ccfa967d2e89",
	})
	use({ -- Companion to Comment plugin, sets code language based on context so you can use different comment styles within the same file, based on what's being commented
		"JoosepAlviste/nvim-ts-context-commentstring",
		commit = "6c30f3c8915d7b31c3decdfe6c7672432da1809d",
	})

	-- Telescope search --
	use({ -- Telescope search
		"nvim-telescope/telescope.nvim",
		commit = "18774ec7929c8a8003a91e9e1f69f6c32258bbfe",
	})
	use({ -- Clipboard/Macro history, searchable with Telescope
		"AckslD/nvim-neoclip.lua",
		config = function()
			require("neoclip").setup()
		end,
		commit = "4e406ae0f759262518731538f2585abb9d269bac",
	})

	-- Treesitter --
	use({ -- better highlighting
		"nvim-treesitter/nvim-treesitter",
		run = ":TSUpdate",
		commit = "557561fbc17269cdd4e9e88ef0ca1a9ff0bbf7e6",
	})

	-- Git --
	use({ -- git decorations in nvim
		"lewis6991/gitsigns.nvim",
		commit = "37d26d718f8120a8c5c107c580c8c98cf89fdf1f",
	})
	-- Automatically set up your configuration after cloning packer.nvim
	if PACKER_BOOTSTRAP then
		require("packer").sync()
	end
end)
