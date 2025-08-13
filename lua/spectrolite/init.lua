local M = {}

---Convert color into another `mode` (color space).
---If `color` is present, return result as coordinates.
---If `color` is omitted/`nil`, capture from selection and replace selection with formatted result
---@param mode string Target color space: `"hex"`, `"hexa"`, `"hsl"`, `"hsla"`, `"hxl"`, `"hxla"`, `"rgb"`, `"rgba"`
---@param color? string Source color to convert from, in CSS-like format
---@param opts? Spectrolite.Config Override config options for this function call
function M.convert(mode, color, opts)
  local utils = require("spectrolite.utils")

  if not utils.check_mode(mode) then
    vim.notify("Mode [" .. mode .. "] is not supported", vim.log.levels.WARN)
    return nil
  end

  local clr, selection

  if not color then
    selection = utils.get_selection()
    clr = utils.read(selection)
  else
    clr = color
  end

  if not clr then
    vim.notify("No input color", vim.log.levels.WARN)
    return nil
  end

  clr = require("spectrolite.modes").parse(clr)
  if not clr then
    vim.notify("Cannot parse color", vim.log.levels.WARN)
    return nil
  end

  local options = require("spectrolite.config").config
  if opts then
    options = vim.tbl_deep_extend("force", options, opts or {})
  end

  clr = require("spectrolite.modes").convert(mode, clr, options)
  if not clr then
    vim.notify("Cannot convert into [" .. mode .. "]", vim.log.levels.WARN)
    return nil
  end

  if not selection then
    return clr
  end

  clr = require("spectrolite.modes").format(mode, clr, options)
  if not clr then
    vim.notify("Cannot format color into [" .. mode .. "]", vim.log.levels.WARN)
    return nil
  end

  utils.write(selection, clr)
end

---Capture color, return coordinates and mode (color space).
---If `mode` is omitted/`nil`, it will be defined automatically.
---If `color` is omitted/`nil`, capture from selection
---@param mode? string Target color space: `"hex"`, `"hexa"`, `"hsl"`, `"hsla"`, `"hxl"`, `"hxla"`, `"rgb"`, `"rgba"`
---@param color? string Source color to convert from, in CSS-like format
---@param opts? Spectrolite.Config Override config options for this function call
function M.capture(mode, color, opts)
  local utils = require("spectrolite.utils")

  if mode and not utils.check_mode(mode) then
    vim.notify("Mode [" .. mode .. "] is not supported", vim.log.levels.WARN)
    return nil
  end

  local clr, selection

  if not color then
    selection = utils.get_selection()
    clr = selection and utils.read(selection)
  else
    clr = color
  end

  if not clr then
    vim.notify("No input color", vim.log.levels.WARN)
    return nil
  end

  if not mode then
    clr, mode = require("spectrolite.modes").parse(clr)
  else
    clr, mode = require("spectrolite.modes").parse(clr, mode)
  end

  if not clr or not mode then
    vim.notify("Cannot parse color", vim.log.levels.WARN)
    return nil
  end

  local options = require("spectrolite.config").config
  if opts then
    options = vim.tbl_deep_extend("force", options, opts or {})
  end

  clr = require("spectrolite.modes").convert(mode, clr, options)

  if not clr then
    vim.notify(
      "Cannot extract values based on defined mode [" .. mode .. "]",
      vim.log.levels.WARN
    )
    return nil
  end

  return clr, mode
end

---Override default configuration
---@param opts? Spectrolite.Config table
function M.setup(opts)
  require("spectrolite.config").setup(opts)
end

return M
