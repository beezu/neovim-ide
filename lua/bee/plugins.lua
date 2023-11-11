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
    commit = "40b9b887d090d5da89a84689b4ca0304a9649f62",
	})
	use({ -- Allows persistent and toggle-able terminals within nvim
		"akinsho/toggleterm.nvim",
    commit = "c80844fd52ba76f48fabf83e2b9f9b93273f418d",
	})

	-- Bufferline --
	use({ -- Adds a buffer line at top of nvim, emulates GUI IDEs
		"akinsho/bufferline.nvim",
    commit = "357cc8f8eeb64702e6fcf2995e3b9becee99a5d3",
	})
	use({ -- "Buffer Bye", it removes buffers intelligently and gives user options to do so as well
		"moll/vim-bbye",
    commit = "25ef93ac5a87526111f43e5110675032dbcacf56",
	})

	-- Theme --
	use({
		"EdenEast/nightfox.nvim",
    commit = "6a6076bd678f825ffbe16ec97807793c3167f1a7",
	})

	-- Statusline --
	use({
		"famiu/feline.nvim",
    commit = "3587f57480b88e8009df7b36dc84e9c7ff8f2c49",
	})

	-- Characters
	use({ -- Adds NerdFont devicon support to Vim for plugins like treesitter to use. Lua fork of Ryanoasis
		"nvim-tree/nvim-web-devicons",
    commit = "3af745113ea537f58c4b1573b64a429fefad9e07",
	})

	-- Markdown Previewer --
	use({
		"iamcco/markdown-preview.nvim",
		run = function()
			vim.fn["mkdp#util#install"]()
		end,
    commit = "a923f5fc5ba36a3b17e289dc35dc17f66d0548ee",
	})

	use({ -- for lsp
		"hrsh7th/cmp-nvim-lsp",
    commit = "44b16d11215dce86f253ce0c30949813c0a90765",
	})
	use({ -- for lsp
		"hrsh7th/cmp-nvim-lua",
    commit = "f12408bdb54c39c23e67cab726264c10db33ada8",
	})
	use({ -- Crates.io dependency helper + crates completions
		"saecki/crates.nvim",
		event = { "BufRead Cargo.toml" },
		config = function()
			require("crates").setup()
		end,
    commit = "58bf989736765cae41fa5d0971027efeca033301",
	})
	use({ -- Autopairs, integrates with both cmp and treesitter
		"windwp/nvim-autopairs",
    commit = "f6c71641f6f183427a651c0ce4ba3fb89404fa9e",
	})

	-- LSP
	use({ -- enable LSP
		"neovim/nvim-lspconfig",
    commit = "e49b1e90c1781ce372013de3fa93a91ea29fc34a",
	})
	use({ -- simple to use language server installer
		"williamboman/mason.nvim",
    commit = "cd7835b15f5a4204fc37e0aa739347472121a54c",
	})
	use({
		"williamboman/mason-lspconfig.nvim",
    commit = "e7b64c11035aa924f87385b72145e0ccf68a7e0a",
	})
	use({ -- for formatters and linters
		"jose-elias-alvarez/null-ls.nvim",
    commit = "0010ea927ab7c09ef0ce9bf28c2b573fc302f5a7",
	})
	use({ -- Highlights other uses of word for LSP
		"RRethy/vim-illuminate",
    commit = "3bd2ab64b5d63b29e05691e624927e5ebbf0fb86",
	})

	-- Misc
	use({ -- Auto indents lines, even blank ones
		"lukas-reineke/indent-blankline.nvim",
    commit = "9301e434dd41154ffe5c3d5b8a5c9acd075ebeff",
	})
	use({ -- Smart commenting
		"numToStr/Comment.nvim",
    commit = "0236521ea582747b58869cb72f70ccfa967d2e89",
	})
	use({ -- Companion to Comment plugin, sets code language based on context so you can use different comment styles within the same file, based on what's being commented
		"JoosepAlviste/nvim-ts-context-commentstring",
    commit = "92e688f013c69f90c9bbd596019ec10235bc51de",
	})

	 -- Telescope search --
	use({ -- Telescope search 
		"nvim-telescope/telescope.nvim",
    commit = "74ce793a60759e3db0d265174f137fb627430355",
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
    commit = "9c4fc86b67c1d68141cef57846d24cbee9b74fb0",
	})

	-- Git --
	use({ -- git decorations in nvim
		"lewis6991/gitsigns.nvim",
    commit = "5a9a6ac29a7805c4783cda21b80a1e361964b3f2",
	})

	-- Automatically set up your configuration after cloning packer.nvim
	if PACKER_BOOTSTRAP then
		require("packer").sync()
	end
end)
