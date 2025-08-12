local M = {}

-- Convert `color` into another `mode` (color space). If `color` is omitted, capture from selection and replace selection with converted color
---@param mode string Target color space: `"hex"`, `"hexa"`, `"hsl"`, `"hsla"`, `"hxl"`, `"hxla"`, `"rgb"`, `"rgba"`
---@param color? string|nil Source color to convert from, in CSS-like format
---@param raw? boolean If `true`, return table of color coordinates instead of formatted string. Default is `false`
---@param noreplace? boolean If `true`, don't replace selection even if sourced as `color` input. Default is `false`
function M.convert(mode, color, raw, noreplace)
  if not require("spectrolite.utils").checked_mode(mode) then
    vim.notify("Mode [" .. mode .. "] is not valid", vim.log.levels.WARN)
    return nil
  end

  color = require("spectrolite.utils").checked_input(color)
  local selection = nil

  if not color then
    selection = require("spectrolite.utils").get_selection()
    color = require("spectrolite.utils").read(selection)
  end

  if not color then
    vim.notify("No explicit input or selection", vim.log.levels.WARN)
    return nil
  end

  color = require("spectrolite.modes").parse(color)

  if not color then
    vim.notify("Couldn't parse color values", vim.log.levels.WARN)
    return nil
  end

  color = require("spectrolite.modes").convert(mode, color)

  if not color then
    vim.notify("Couldn't convert into [" .. mode .. "]", vim.log.levels.WARN)
    return nil
  end

  if not raw then
    color = require("spectrolite.modes").format(color)
    if not color then
      vim.notify("Couldn't format coordinates into string", vim.log.levels.WARN)
    end
  end

  if selection and not noreplace then
    local output = vim.inspect(color):gsub("\n", ""):gsub("%s+", " ")
    require("spectrolite.utils").write(selection, output)
  end

  return color
end

-- Override default configuration
---@param opts? Spectrolite.Config
M.setup = function(opts)
  require("spectrolite.config").setup(opts)
end

return M
