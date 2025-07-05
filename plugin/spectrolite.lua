-- this stuff will be executed at plugin load time

if vim.g.loaded_spectrolite == 1 then
  return
end

vim.g.loaded_spectrolite = 1

-- user commands

vim.api.nvim_create_user_command("SpectroliteHex", function()
  require("spectrolite").to_hex()
end, { range = true })

vim.api.nvim_create_user_command("SpectroliteRgb", function()
  require("spectrolite").to_rgb()
end, { range = true })

vim.api.nvim_create_user_command("SpectroliteHsl", function()
  require("spectrolite").to_hsl()
end, { range = true })

vim.api.nvim_create_user_command("SpectroliteHxl", function()
  require("spectrolite").to_hxl()
end, { range = true })
