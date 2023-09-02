local opts = { noremap = true, silent = true }

-- local term_opts = { silent = true }

-- Shorten function name
local keymap = vim.api.nvim_set_keymap

-- Map comma as leader key
-- keymap("", "<Space>", "<Nop>", opts)
vim.g.mapleader = ","
vim.g.maplocalleader = ","
-- [[ Leader keys ]] --
keymap("n", "<leader>a", "<cmd>Telescope live_grep<cr>", opts)
keymap("n", "<leader>b", "<cmd>Bdelete!<cr>", opts)
keymap("n", "<leader>c", "<cmd>lua require('telescope').extensions.neoclip.default()<cr>", opts)
keymap("n", "<leader>d", "<cmd>NvimTreeToggle<cr>", opts)
keymap("n", "<leader>f", "<cmd>Telescope find_files<cr>", opts)
keymap("n", "<leader>h", "<cmd>split<cr>", opts)
keymap("n", "<leader>n", "<cmd>lua vim.lsp.buf.format()<cr>", opts)
keymap("n", "<leader>t", "<cmd>tabnew<cr>", opts)
keymap("n", "<leader>u", "<cmd>PackerSync<cr>", opts)
keymap("n", "<leader>v", "<cmd>vsplit<cr>", opts)
keymap("n", "<leader>z", "<cmd>lua require('cmp').setup.buffer {enabled = false }<cr>", opts)
keymap("n", "<leader>Z", "<cmd>lua require('cmp').setup.buffer {enabled = true }<cr>", opts)

-- Modes
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",

-- Normal --
-- Better window navigation
keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-k>", "<C-w>k", opts)
keymap("n", "<C-l>", "<C-w>l", opts)

-- Resize with arrows
keymap("n", "<C-Up>", ":resize +2<CR>", opts)
keymap("n", "<C-Down>", ":resize -2<CR>", opts)
keymap("n", "<C-Left>", ":vertical resize +2<CR>", opts)
keymap("n", "<C-Right>", ":vertical resize -2<CR>", opts)

-- Navigate buffers
keymap("n", "<S-l>", ":bnext<CR>", opts)
keymap("n", "<S-h>", ":bprevious<CR>", opts)

-- Move text up and down
keymap("n", "<A-j>", "<Esc>:m .+1<CR>==gi", opts)
keymap("n", "<A-k>", "<Esc>:m .-2<CR>==gi", opts)

-- Insert --
-- Exit insert mode with jj
keymap("i", "jj", "<ESC>", opts)

-- Command --
-- Exit command mode with jj
keymap("c", "jj", "<ESC>", opts)

-- Stay in indent mode
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- Move text up and down
keymap("v", "<A-j>", ":m .+1<CR>==", opts)
keymap("v", "<A-k>", ":m .-2<CR>==", opts)

-- Keep yanked text when deleting other text
keymap("v", "p", '"_dP', opts)

-- Visual Block --
-- Move text up and down
keymap("x", "J", ":move '>+1<CR>gv-gv", opts)
keymap("x", "K", ":move '<-2<CR>gv-gv", opts)
keymap("x", "<A-j>", ":move '>+1<CR>gv-gv", opts)
keymap("x", "<A-k>", ":move '<-2<CR>gv-gv", opts)

-- Terminal --
-- Better terminal navigation
-- keymap("t", "<C-h>", "<C-\\><C-N><C-w>h", term_opts)
-- keymap("t", "<C-j>", "<C-\\><C-N><C-w>j", term_opts)
-- keymap("t", "<C-k>", "<C-\\><C-N><C-w>k", term_opts)
-- keymap("t", "<C-l>", "<C-\\><C-N><C-w>l", term_opts)
