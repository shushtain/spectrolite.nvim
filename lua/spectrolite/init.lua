local config = require("spectrolite.config")
local parse = require("spectrolite.parse")
local convert = require("spectrolite.convert")
local format = require("spectrolite.format")
local utils = require("spectrolite.utils")
local M = {}

M.to_hex = function()
  local selection = utils.read()
  if not selection then
    return nil
  end

  local color_in = parse.auto(selection.text)
  if not color_in then
    return nil
  end

  local color_out = convert.to_hex(color_in)
  selection.text = format.hex(color_out)
  utils.write(selection)
end

M.to_rgb = function()
  local selection = utils.read()
  if not selection then
    return nil
  end

  local color_in = parse.auto(selection.text)
  if not color_in then
    return nil
  end

  local color_out = color_in
  selection.text = format.rgb(color_out)
  utils.write(selection)
end

M.to_hsl = function()
  local selection = utils.read()
  if not selection then
    return nil
  end

  local color_in = parse.auto(selection.text)
  if not color_in then
    return
  end

  local color_out = convert.to_hsl(color_in)
  selection.text = format.hsl(color_out)
  utils.write(selection)
end

M.to_hxl = function()
  local selection = utils.read()
  if not selection then
    return nil
  end

  local color_in = parse.auto(selection.text)
  if not color_in then
    return nil
  end

  local color_out = convert.to_hxl(color_in)
  selection.text = format.hxl(color_out)
  utils.write(selection)
end

---Setup function for Spectrolite
---@param options Spectrolite.Config|nil
M.setup = function(options)
  config.__setup(options)
end

return M
