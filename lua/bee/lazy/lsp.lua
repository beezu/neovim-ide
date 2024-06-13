return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "RRethy/vim-illuminate",
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-nvim-lua",
    "neovim/nvim-lspconfig",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-cmdline",
    "hrsh7th/nvim-cmp",
    "L3MON4D3/LuaSnip",
    "saadparwaiz1/cmp_luasnip",
    "j-hui/fidget.nvim",
  },

  config = function()
    local cmp = require("cmp")
    local cmp_lsp = require("cmp_nvim_lsp")
    local capabilities = vim.tbl_deep_extend(
      "force",
      {},
      vim.lsp.protocol.make_client_capabilities(),
      cmp_lsp.default_capabilities()
    )

    -- gdscript support, requires godot to be running
    require("lspconfig").gdscript.setup({
      flags = {
        debounce_text_changes = 150,
      },
    })

    -- pyright support
    require("lspconfig").pyright.setup({
      settings = {
        python = {
          analysis = {
            typeCheckingMode = "off",
          },
        },
      },
    })

    -- swift support via xcode
    require("lspconfig").sourcekit.setup({
      cmd = {
        "/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/sourcekit-lsp",
      },
      root_dir = vim.fs.dirname,
    })


    require("fidget").setup({})
    require("mason").setup()
    require("mason-lspconfig").setup({
      ensure_installed = {
        "lua_ls",
        -- "gdscript", -- why won't this install here, but Mason does it fine manually? the world may never know.
        -- "gdtoolkit", -- this name isn't it either.
        "pyright",
        "rust_analyzer",
        "powershell_es",
        "yamlls",
        "dockerls",
      },
      handlers = {
        function(server_name) -- default handler (optional)
          require("lspconfig")[server_name].setup({
            capabilities = capabilities,
          })
        end,

        ["lua_ls"] = function()
          local lspconfig = require("lspconfig")
          lspconfig.lua_ls.setup({
            capabilities = capabilities,
            settings = {
              Lua = {
                diagnostics = {
                  globals = {
                    "love",
                    "vim",
                    "it",
                    "describe",
                    "before_each",
                    "after_each",
                  },
                },
                workspace = {
                  library = {
                    "{$3rd}/love2d/library",
                  },
                  checkThirdParty = { false },
                },
                telemetry = { enable = false },
              },
            },
          })
        end,
      },
    })

    local cmp_select = { behavior = cmp.SelectBehavior.Select }

    cmp.setup({
      snippet = {
        expand = function(args)
          require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
        end,
      },
      mapping = cmp.mapping.preset.insert({
        ["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),
        ["<S-Tab>"] = cmp.mapping.select_prev_item(cmp_select),
        ["<C-n>"] = cmp.mapping.select_next_item(cmp_select),
        ["<Tab>"] = cmp.mapping.select_next_item(cmp_select),
        ["<C-y>"] = cmp.mapping.confirm({ select = true }),
        ["<C-Space>"] = cmp.mapping.complete(),
      }),
      format = function(entry, vim_item)
        -- Kind icons
        -- vim_item.kind = string.format("%s", kind_icons[vim_item.kind])
        -- vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind], vim_item.kind) -- This concatonates the icons with the name of the item kind
        vim_item.menu = ({
          nvim_lsp = "[LSP]",
          luasnip = "[Snippet]",
          powershell_es = "[pwsh]",
          buffer = "[Buffer]",
          path = "[Path]",
          crates = "[Rust]",
          swift = "[Swift]",
          python = "[pyright]",
        })[entry.source.name]
        return vim_item
      end,
      sources = cmp.config.sources({
        { name = "luasnip",       priority = 5 },
        { name = "nvim_lsp",      priority = 4 },
        { name = "powershell_es", priority = 2 },
        { name = "buffer",        priority = 2 },
        { name = "path",          priority = 1 },
        { name = "crates",        priority = 2 },
        { name = "swift",         priority = 2 },
        { name = "pyright",       priority = 2 },
      }),
    })

    vim.diagnostic.config({
      -- update_in_insert = true,
      float = {
        focusable = false,
        style = "minimal",
        border = "rounded",
        source = "always",
        header = "",
        prefix = "",
      },
    })
  end,
}
