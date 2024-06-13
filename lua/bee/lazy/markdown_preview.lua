return {
  -- Markdown Previewer --
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    event = { "BufRead *.md" },
    ft = { "markdown" },
    -- This is what's in the offical docs but doesn't seem to work correctly. Install manually by executing:
    -- ~/.local/share/nvim/lazy/markdown-preview/app/install.sh
    build = function() vim.fn["mkdp#util#install"]() end,
  }
}
