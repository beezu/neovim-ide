return {
  {
    "folke/trouble.nvim",
    opts = {}, -- for default options, refer to the configuration section for custom setup.
    cmd = "Trouble",
    keys = {
      {
        "<leader>t",
        "<cmd>Trouble diagnostics toggle win.position=right<cr>",
        desc = "Diagnostics (Trouble)",
      },
      {
        "<leader>tt",
        "<cmd>Trouble diagnostics toggle next jump=true<cr>",
        desc = "Diagnostics (Trouble)",
      },
    },
  }
}
