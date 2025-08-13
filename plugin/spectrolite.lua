if vim.g.spectrolite_loaded then
  return
end
vim.g.spectrolite_loaded = true

-- TODO:
-- Spectrolite! for noreplace
-- Raw? (hex!)
-- round mode

vim.api.nvim_create_user_command("Spectrolite", function(_)
  vim.ui.select(vim.tbl_keys(require("spectrolite.utils").modes), {
    prompt = "Target color space:",
    format_item = function(mode)
      return require("spectrolite.utils").modes[mode]
    end,
  }, function(mode)
    if mode then
      vim.ui.input({
        prompt = "Source color (will use selection if empty): ",
      }, function(input)
        if input then
          require("spectrolite").convert(mode, input)
        end
      end)
    end
  end)
end, {
  range = true,
  register = true,
  desc = "Convert color",
})

vim.api.nvim_create_user_command("SpectroliteHex", function(cmd)
  require("spectrolite").convert("hex", cmd.args)
end, {
  range = true,
  register = true,
  nargs = "?",
  desc = "Convert color to HEX",
})

vim.api.nvim_create_user_command("SpectroliteHsl", function(cmd)
  require("spectrolite").convert("hsl", cmd.args)
end, {
  range = true,
  register = true,
  nargs = "?",
  desc = "Convert color to HSL",
})

vim.api.nvim_create_user_command("SpectroliteHxl", function(cmd)
  require("spectrolite").convert("hxl", cmd.args)
end, {
  range = true,
  register = true,
  nargs = "?",
  desc = "Convert color to Cubehelix",
})

vim.api.nvim_create_user_command("SpectroliteRgb", function(cmd)
  require("spectrolite").convert("rgb", cmd.args)
end, {
  range = true,
  register = true,
  nargs = "?",
  desc = "Convert color to RGB",
})
