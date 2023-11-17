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
		"freddiehaddad/feline.nvim",
    commit = "62a9f4fd4fcf46cb87b7868323a1e9aef5b08028",
	})

	-- Characters
	use({ -- Adds NerdFont devicon support to Vim for plugins like treesitter to use. Lua fork of Ryanoasis
		"nvim-tree/nvim-web-devicons",
    commit = "3523d6e6d40ab11fd66c1b2732b3d6b60affa951",
	})

	-- Markdown Previewer --
	use({
		"iamcco/markdown-preview.nvim",
		run = function()
			vim.fn["mkdp#util#install"]()
		end,
    commit = "a923f5fc5ba36a3b17e289dc35dc17f66d0548ee",
	})
	-- Completions and Linting --
	-- Cmp
	use({ -- The completion plugin
		"hrsh7th/nvim-cmp",
    commit = "0b751f6beef40fd47375eaf53d3057e0bfa317e4",
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
    commit = "8ee981b4a91f536f52add291594e89fb6645e451",
	})
	use({ -- snippet completions
		"saadparwaiz1/cmp_luasnip",
    commit = "05a9ab28b53f71d1aece421ef32fee2cb857a843",
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
    commit = "f47c77d99f11362ddc2f4891f35407fb0b76d485",
	})
	use({ -- Autopairs, integrates with both cmp and treesitter
		"windwp/nvim-autopairs",
    commit = "0f04d78619cce9a5af4f355968040f7d675854a1",
	})

	-- Snippets
	use({ --snippet engine
		"L3MON4D3/LuaSnip",
    commit = "1f4ad8bb72bdeb60975e98652636b991a9b7475d",
	})
	use({ -- a bunch of snippets to use
		"rafamadriz/friendly-snippets",
    commit = "43727c2ff84240e55d4069ec3e6158d74cb534b6",
	})

	-- LSP
	use({ -- enable LSP
		"neovim/nvim-lspconfig",
    commit = "48347089666d5b77d054088aa72e4e0b58026e6e",
	})
	use({ -- simple to use language server installer
		"williamboman/mason.nvim",
    commit = "41e75af1f578e55ba050c863587cffde3556ffa6",
	})
	use({
		"williamboman/mason-lspconfig.nvim",
    commit = "ab640b38ca9fa50d25d2d249b6606b9456b628d5",
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
