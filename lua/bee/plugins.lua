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
		commit = "64ae65fea395d8dc461e3884688f340dd43950ba",
	})
	use({ -- Useful lua functions used by lots of plugins
		"nvim-lua/plenary.nvim",
		commit = "4b7e52044bbb84242158d977a50c4cbcd85070c7",
	})
	use({ -- Allows plugins to use popups instead of splits
		"nvim-lua/popup.nvim",
		commit = "b7404d35d5d3548a82149238289fa71f7f6de4ac",
	})
	use({ -- Lua-based file explorer
		"nvim-tree/nvim-tree.lua",
		commit = "29788cc32a153e42b2fe48344d315da8367fc6fa",
	})
	use({ -- Allows persistent and toggle-able terminals within nvim
		"akinsho/toggleterm.nvim",
		commit = "b02a1674bd0010d7982b056fd3df4f717ff8a57a",
	})
	-- use({ "lewis6991/impatient.nvim" }) -- Speeds up loading nvim lua modules
	-- use({ "goolord/alpha-nvim" }) -- Greeter for nvim

	-- Bufferline --
	use({ -- Adds a buffer line at top of nvim, emulates GUI IDEs
		"akinsho/bufferline.nvim",
		commit = "4ecfa81e470a589e74adcde3d5bb1727dd407363",
	})
	use({ -- "Buffer Bye", it removes buffers intelligently and gives user options to do so as well
		"moll/vim-bbye",
		commit = "25ef93ac5a87526111f43e5110675032dbcacf56",
	})
	-- Theme --
	use({
		"EdenEast/nightfox.nvim",
		commit = "9c3756ae21743c9634923cea788c4cca0eafccf2",
	})

	-- Statusline --
	use({
		"feline-nvim/feline.nvim",
		commit = "573e6d1e213de976256c84e1cb2f55665549b828",
	})

	-- Characters
	use({ -- Adds NerdFont devicon support to Vim for plugins like treesitter to use. Lua fork of Ryanoasis
		"kyazdani42/nvim-web-devicons",
		commit = "05e1072f63f6c194ac6e867b567e6b437d3d4622",
	})

	-- Markdown Previewer --
	use({
		"iamcco/markdown-preview.nvim",
		run = function()
			vim.fn["mkdp#util#install"]()
		end,
	})
	-- Completions and Linting --
	-- Cmp
	use({ -- The completion plugin
		"hrsh7th/nvim-cmp",
		commit = "8bbaeda725d5db6e4e1be2867a64b43bf547cf06",
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
		commit = "23c51b2a3c00f6abc4e922dbd7c3b9aca6992063",
	})
	use({ -- snippet completions
		"saadparwaiz1/cmp_luasnip",
		commit = "18095520391186d634a0045dacaa346291096566",
	})
	use({ -- for lsp
		"hrsh7th/cmp-nvim-lsp",
		commit = "59224771f91b86d1de12570b4070fe4ad7cd1eeb",
	})
	use({ -- for lsp
		"hrsh7th/cmp-nvim-lua",
		commit = "d276254e7198ab7d00f117e88e223b4bd8c02d21",
	})
	use({ -- Crates.io dependency helper + crates completions
		"saecki/crates.nvim",
		commit = "a70328ae638e20548bcfc64eb9561101104b3008",
		event = { "BufRead Cargo.toml" },
		config = function()
			require("crates").setup()
		end,
	})
	use({ -- Autopairs, integrates with both cmp and treesitter
		"windwp/nvim-autopairs",
		commit = "b5994e6547d64f781cfca853a1aa6174d238fe0e",
	})

	-- Snippets
	use({ --snippet engine
		"L3MON4D3/LuaSnip",
		commit = "8b25e74761eead3dc47ce04b5e017fd23da7ad7e",
	})
	use({ -- a bunch of snippets to use
		"rafamadriz/friendly-snippets",
		commit = "2379c6245be10fbf0ebd057f0d1f89fe356bf8bc",
	})

	-- LSP
	use({ -- enable LSP
		"neovim/nvim-lspconfig",
		commit = "54eb2a070a4f389b1be0f98070f81d23e2b1a715",
	})
	use({ -- simple to use language server installer
		"williamboman/mason.nvim",
		commit = "bfee884583ea347e5d1467839ac5e08ca01f66a3",
	})
	use({
		"williamboman/mason-lspconfig.nvim",
		commit = "e8bd50153b94cc5bbfe3f59fc10ec7c4902dd526",
	})
	use({ -- for formatters and linters
		"jose-elias-alvarez/null-ls.nvim",
		commit = "5d8e925d31d8ef8462832308c016ac4ace17597a",
	})
	use({ -- Highlights other uses of word for LSP
		"RRethy/vim-illuminate",
		commit = "a6d0b28ea7d6b9d139374be1f94a16bd120fcda3",
	})

	-- Misc
	use({ -- Auto indents lines, even blank ones
		"lukas-reineke/indent-blankline.nvim",
		commit = "c4c203c3e8a595bc333abaf168fcb10c13ed5fb7",
	})
	use({ -- Smart commenting
		"numToStr/Comment.nvim",
		commit = "5f01c1a89adafc52bf34e3bf690f80d9d726715d",
	})
	use({ -- Companion to Comment plugin, sets code language based on context so you can use different comment styles within the same file, based on what's being commented
		"JoosepAlviste/nvim-ts-context-commentstring",
		commit = "32d9627123321db65a4f158b72b757bcaef1a3f4",
	})

	-- Telescope search --
	use({ -- Telescope search
		"nvim-telescope/telescope.nvim",
		commit = "cabf991b1d3996fa6f3232327fc649bbdf676496",
	})
	use({ -- Clipboard/Macro history, searchable with Telescope
		"AckslD/nvim-neoclip.lua",
		commit = "3e0b9a134838c7356d743f84a272c92410c47d8d",
		config = function()
			require("neoclip").setup()
		end,
	})

	-- Treesitter --
	use({ -- better highlighting
		"nvim-treesitter/nvim-treesitter",
		commit = "ee095abeac5842943a94a27c0ca75c61e7c614a2",
		run = ":TSUpdate",
	})
	use({ -- Rainbow parentheses for treesitter
		"p00f/nvim-ts-rainbow",
		commit = "064fd6c0a15fae7f876c2c6dd4524ca3fad96750",
	})

	-- Git --
	use({ -- git decorations in nvim
		"lewis6991/gitsigns.nvim",
		commit = "71644a2907adc076f1c5e712f59d897f5197d5d6",
	})

	-- Debugger --
	use({
		"mfussenegger/nvim-dap",
		commit = "68d96871118a13365f3c33e4838990030fff80ec",
	})
	-- Debugger UI --
	use({
		"rcarriga/nvim-dap-ui",
		commit = "54365d2eb4cb9cfab0371306c6a76c913c5a67e3",
		requires = { "mfussenegger/nvim-dap" },
	})
	-- Automatically set up your configuration after cloning packer.nvim
	if PACKER_BOOTSTRAP then
		require("packer").sync()
	end
end)
