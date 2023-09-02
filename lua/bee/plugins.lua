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
    commit = "267282a9ce242bbb0c5dc31445b6d353bed978bb",
	})
	use({ -- Allows plugins to use popups instead of splits
		"nvim-lua/popup.nvim",
    commit = "b7404d35d5d3548a82149238289fa71f7f6de4ac",
	})
	use({ -- Lua-based file explorer
		"nvim-tree/nvim-tree.lua",
    commit = "4bd30f0137e44dcf3e74cc1164efb568f78f2b02",
	})
	use({ -- Allows persistent and toggle-able terminals within nvim
		"akinsho/toggleterm.nvim",
    commit = "00c13dccc78c09fa5da4c5edda990a363e75035e",
	})
	-- use({ "lewis6991/impatient.nvim" }) -- Speeds up loading nvim lua modules
	-- use({ "goolord/alpha-nvim" }) -- Greeter for nvim

	-- Bufferline --
	use({ -- Adds a buffer line at top of nvim, emulates GUI IDEs
		"akinsho/bufferline.nvim",
    commit = "99f0932365b34e22549ff58e1bea388465d15e99",
	})
	use({ -- "Buffer Bye", it removes buffers intelligently and gives user options to do so as well
		"moll/vim-bbye",
    commit = "25ef93ac5a87526111f43e5110675032dbcacf56",
	})
	-- Theme --
	use({
		"EdenEast/nightfox.nvim",
    commit = "77aa7458d2b725c2d9ff55a18befe1b891ac473e",
	})

	-- Statusline --
	use({
		"famiu/feline.nvim",
    commit = "d48b6f92c6ccdd6654c956f437be49ea160b5b0c",
	})

	-- Characters
	use({ -- Adds NerdFont devicon support to Vim for plugins like treesitter to use. Lua fork of Ryanoasis
		"nvim-tree/nvim-web-devicons",
    commit = "efbfed0567ef4bfac3ce630524a0f6c8451c5534",
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
    commit = "c4e491a87eeacf0408902c32f031d802c7eafce8",
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
    commit = "18095520391186d634a0045dacaa346291096566",
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
    commit = "4ce7c51b881e58f1e2f8f437f30e4e583cbac319",
	})
	use({ -- Autopairs, integrates with both cmp and treesitter
		"windwp/nvim-autopairs",
    commit = "ae5b41ce880a6d850055e262d6dfebd362bb276e",
	})

	-- Snippets
	use({ --snippet engine
		"L3MON4D3/LuaSnip",
    commit = "e81cbe6004051c390721d8570a4a0541ceb0df10",
	})
	use({ -- a bunch of snippets to use
		"rafamadriz/friendly-snippets",
    commit = "bc38057e513458cb2486b6cd82d365fa294ee398",
	})

	-- LSP
	use({ -- enable LSP
		"neovim/nvim-lspconfig",
    commit = "b6091272422bb0fbd729f7f5d17a56d37499c54f",
	})
	use({ -- simple to use language server installer
		"williamboman/mason.nvim",
    commit = "fe9e34a9ab4d64321cdc3ecab4ea1809239bb73f",
	})
	use({
		"williamboman/mason-lspconfig.nvim",
    commit = "e86a4c84ff35240639643ffed56ee1c4d55f538e",
	})
	use({ -- for formatters and linters
		"jose-elias-alvarez/null-ls.nvim",
    commit = "db09b6c691def0038c456551e4e2772186449f35",
	})
	use({ -- Highlights other uses of word for LSP
		"RRethy/vim-illuminate",
    commit = "a2907275a6899c570d16e95b9db5fd921c167502",
	})

	-- Misc
	use({ -- Auto indents lines, even blank ones
		"lukas-reineke/indent-blankline.nvim",
    commit = "4541d690816cb99a7fc248f1486aa87f3abce91c",
	})
	use({ -- Smart commenting
		"numToStr/Comment.nvim",
    commit = "176e85eeb63f1a5970d6b88f1725039d85ca0055",
	})
	use({ -- Companion to Comment plugin, sets code language based on context so you can use different comment styles within the same file, based on what's being commented
		"JoosepAlviste/nvim-ts-context-commentstring",
    commit = "e9062e2dfb9854e6a927370f2d720de354c88524",
	})

	 -- Telescope search --
	use({ -- Telescope search 
		"nvim-telescope/telescope.nvim",
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
    commit = "ee107fc759647293a84ad42b867f518331364fbe",
	})
--	use({ -- Rainbow parentheses for treesitter
--		"p00f/nvim-ts-rainbow",
--    commit = "ef95c15a935f97c65a80e48e12fe72d49aacf9b9",
--	})

	-- Git --
	use({ -- git decorations in nvim
		"lewis6991/gitsigns.nvim",
    commit = "5d73da785a3c05fd63ac31769079db05169a6ec7",
	})

	-- Debugger --
	use({
		"mfussenegger/nvim-dap",
    commit = "2f28ea843bcdb378b171a66ddcd568516e431d55",
	})
	-- Debugger UI --
	use({
		"rcarriga/nvim-dap-ui",
		requires = { "mfussenegger/nvim-dap" },
    commit = "85b16ac2309d85c88577cd8ee1733ce52be8227e",
	})
	-- Automatically set up your configuration after cloning packer.nvim
	if PACKER_BOOTSTRAP then
		require("packer").sync()
	end
end)
