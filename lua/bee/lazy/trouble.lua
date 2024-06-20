return {
  {
    "folke/trouble.nvim",
    opts = {}, -- for default options, refer to the configuration section for custom setup.
    cmd = "Trouble",
    keys = {
      {
        "<leader>tt",
        "<cmd>Trouble diagnostics toggle win.position=right<cr>",
        desc = "Diagnostics (Trouble)",
      },
      {
        "<leader>tn",
        "<cmd>Trouble diagnostics toggle next jump=true<cr>",
        desc = "Diagnostics (Trouble)",
      },
      {
        "<leader>tp",
        "<cmd>Trouble diagnostics toggle prev jump=true<cr>",
        desc = "Diagnostics (Trouble)",
      },
    },
  }
}
