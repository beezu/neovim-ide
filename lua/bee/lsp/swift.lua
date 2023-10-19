require'lspconfig'.sourcekit.setup{
  cmd = {'/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/sourcekit-lsp'},
  root_dir = vim.fs.dirname
}
