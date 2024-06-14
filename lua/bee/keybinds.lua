local opts = { noremap = true, silent = true }
local keymap = vim.api.nvim_set_keymap

-- Map leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Telescope --
keymap("n", "<leader>a", "<cmd>Telescope live_grep<cr>", opts) -- fzf
keymap("n", "<leader>f", "<cmd>Telescope find_files<cr>", opts) -- search filenames only
keymap("n", "<leader>c", "<cmd>lua require('telescope').extensions.neoclip.default()<cr>", opts) -- buffer history browser

-- LSP binds --
keymap("n", "<leader>z", "<cmd>lua require('cmp').setup.buffer {enabled = false }<cr>", opts)
keymap("n", "<leader>Z", "<cmd>lua require('cmp').setup.buffer {enabled = true }<cr>", opts)

-- Splits --
keymap("n", "<leader>t", "<cmd>tabnew<cr>", opts)
keymap("n", "<leader>v", "<cmd>vsplit<cr>", opts)
keymap("n", "<leader>h", "<cmd>split<cr>", opts)

-- Buffer -- 
keymap("n", "<leader>b", "<cmd>Bdelete!<cr>", opts)

-- Use LSP to format buffer --
keymap("n", "<leader>n", "<cmd>lua vim.lsp.buf.format()<cr>", opts)

-- Markdown Previewer --
keymap("n", "<leader>m", "<cmd>MarkdownPreview<cr>", opts)

-- Trees --
keymap("n", "<leader>d", "<cmd>NvimTreeToggle<cr>", opts)
keymap("n", "<leader>u", "<cmd>UndotreeToggle<cr>", opts)

-- Better pane navigation --
keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-k>", "<C-w>k", opts)
keymap("n", "<C-l>", "<C-w>l", opts)

-- Resize panes with arrows --
keymap("n", "<C-Up>", ":resize +2<CR>", opts)
keymap("n", "<C-Down>", ":resize -2<CR>", opts)
keymap("n", "<C-Left>", ":vertical resize +2<CR>", opts)
keymap("n", "<C-Right>", ":vertical resize -2<CR>", opts)

-- Navigate buffers --
keymap("n", "<S-l>", ":bnext<CR>", opts)
keymap("n", "<S-h>", ":bprevious<CR>", opts)

-- Exit modes with jj --
keymap("i", "jj", "<ESC>", opts)
keymap("c", "jj", "<ESC>", opts)

-- Stay in indent mode --
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- Keep yanked text when deleting other text --
keymap("v", "p", '"_dP', opts)

-- Move text up and down in Visual Block --
keymap("x", "J", ":move '>+1<CR>gv-gv", opts)
keymap("x", "K", ":move '<-2<CR>gv-gv", opts)
keymap("x", "<A-j>", ":move '>+1<CR>gv-gv", opts)
keymap("x", "<A-k>", ":move '<-2<CR>gv-gv", opts)

-- Treesitter Context --
vim.keymap.set("n", "<leader>g", function()
  require("treesitter-context").go_to_context(vim.v.count1)
end, { silent = true })

-- Toggle line wrap --
keymap("n", "<leader>ww", ":set wrap!<cr>", opts)

-- Cellular Automaton --
keymap("n", "<leader>ccc", "<cmd>CellularAutomaton make_it_rain<cr>", opts)
keymap("n", "<leader>ccx", "<cmd>CellularAutomaton game_of_life<cr>", opts)
keymap("n", "<leader>ccv", "<cmd>CellularAutomaton scramble<cr>", opts)
