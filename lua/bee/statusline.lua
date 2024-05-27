local status_ok, _ = pcall(require, "lualine")
if not status_ok then
  return
end

require('lualine').setup()
