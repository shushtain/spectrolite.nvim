local M = {}

-- FIX: format() vs print()

---Read from selection. Multi-line input is not supported.
---Does not check if valid color is read. Use `parse()` to validate output.
---@return string? str Captured string. `nil` if selection is multi-line
---@return Spectrolite.Selection? selection Captured selection
function M.read()
  local utils = require("spectrolite.utils")

  local sel = utils.get_selection()
  if not sel then
    vim.notify("Cannot capture selection", vim.log.levels.WARN)
    return nil
  end

  local selection = utils.validate_selection(sel)
  if not selection then
    vim.notify("Cannot validate selection", vim.log.levels.WARN)
    return nil
  end

  local str = utils.read(selection)
  if not str then
    vim.notify("Cannot read from selection", vim.log.levels.WARN)
    return nil
  end

  return str, selection
end

---Parse `str` into color coordinates with no conversion.
---If `mode` is present, `str` must be in that mode.
---If `mode` is omitted/`nil`, try against each available.
---@param str string Color in CSS-like format
---@param mode? Spectrolite.Modes Mode (color space) to parse into
---@return Spectrolite.Colors? clr Color coordinates
---@return Spectrolite.Modes? mode_out Echoed from input or auto-defined
function M.parse(str, mode)
  local input = str:lower()
  local clr, mode_out

  if mode then
    clr = require("spectrolite.modes." .. mode).parse(input)
    mode_out = mode
  else
    for mode_try in vim.tbl_keys(M.modes) do
      clr = require("spectrolite.modes." .. mode_try).parse(input)
      mode_out = mode_try
      if clr then
        break
      end
    end
  end

  if not clr then
    if mode then
      vim.notify(
        "Cannot parse from "
          .. vim.inspect(str)
          .. " into mode "
          .. vim.inspect(mode),
        vim.log.levels.WARN
      )
    else
      vim.notify("Cannot parse from " .. vim.inspect(str), vim.log.levels.WARN)
    end
    return nil
  end

  return clr, mode_out
end

---Turn color coordinates into values between `0` and `1` for each channel.
---@param mode Spectrolite.Modes Mode (color space) to normalize from
---@param clr Spectrolite.Colors Color coordinates
---@return Spectrolite.Norm? norm Normalized coordinates
function M.normalize(mode, clr)
  local norm = require("spectrolite.modes." .. mode).normalize(clr)

  if not norm then
    vim.notify("Cannot normalize " .. vim.inspect(clr), vim.log.levels.WARN)
    return nil
  end

  return norm
end

---Denormalize coordinates into color values of `mode`.
---@param mode Spectrolite.Modes Mode (color space) to convert into
---@param norm Spectrolite.Norm Normalized coordinates. Typically received from `normalize()`
---@param opts? Spectrolite.Config Temporary config overrides
---@return Spectrolite.Colors? clr Color coordinates
function M.denormalize(mode, norm, opts)
  local options = require("spectrolite.config").config
  options = vim.tbl_deep_extend("force", options, opts or {})

  local clr = require("spectrolite.modes." .. mode).denormalize(norm, options)

  if not clr then
    vim.notify(
      "Cannot denormalize "
        .. vim.inspect(norm)
        .. " into mode "
        .. vim.inspect(mode),
      vim.log.levels.WARN
    )
    return nil
  end

  return clr
end

---Apply CSS-like formatting to color coordinates.
---@param mode Spectrolite.Modes Mode (color space) to format
---@param clr Spectrolite.Colors Color coordinates
---@param opts? Spectrolite.Config Temporary config overrides
---@return Spectrolite.Colors? clr_out Color coordinates
function M.format(mode, clr, opts)
  local options = require("spectrolite.config").config
  options = vim.tbl_deep_extend("force", options, opts or {})

  local str = require("spectrolite.modes." .. mode).format(clr, options)

  if not str then
    vim.notify(
      "Cannot format " .. vim.inspect(clr) .. " into mode " .. vim.inspect(mode),
      vim.log.levels.WARN
    )
    return nil
  end

  return str
end

---Replace selected area with `str`.
---Meant to be used only with validated selection from `read()`.
---@param selection Spectrolite.Selection Selection received from `read()`
---@param str string Color in CSS-like format
---@return boolean? status `true` if written, `false` if tried, `nil` if missing arguments
function M.write(selection, str)
  local utils = require("spectrolite.utils")

  local status = utils.write(selection, str)
  if not status then
    vim.notify("Cannot write to buffer", vim.log.levels.WARN)
  end

  return status
end

---Convert between color modes.
---@param mode_in Spectrolite.Modes Mode (color space) to convert from
---@param mode_out Spectrolite.Modes Mode (color space) to convert into
---@param str string Color in CSS-like format.
---@param opts? Spectrolite.Config Temporary config overrides
---@return string? str_out Color in CSS-like format
function M.convert(mode_in, mode_out, str, opts)
  local clr_in = M.parse(str, mode_in)
  if not clr_in then
    return nil
  end

  local norm = M.normalize(mode_in, clr_in)
  if not norm then
    return nil
  end

  local clr_out = M.denormalize(mode_out, norm, opts)
  if not clr_out then
    return nil
  end

  local str_out = M.format(mode_out, clr_out, opts)
  if not str_out then
    return nil
  end

  return str_out
end

---Override default configuration.
---@param opts? Spectrolite.Config table
function M.setup(opts)
  require("spectrolite.config").setup(opts)
end

return M
