---@class Spectrolite.SRGB.RGBA: Spectrolite.SRGB.Colors
---@field r number Red [0-255]
---@field g number Green [0-255]
---@field b number Blue [0-255]
---@field a number Alpha [0-1]

---@type Spectrolite.SRGB.Model
local M = {}

function M.parse(str)
  local r, g, b, a = str:match(
    "rgba%s*%(%s*([%d%.]+)[,%s]+([%d%.]+)[,%s]+([%d%.]+)[/,%s]+([%d%.]+%%?)%s*%)"
  )

  if not a then
    return nil
  end

  r = tonumber(r)
  g = tonumber(g)
  b = tonumber(b)

  if a:match("%%") then
    a = a:gsub("%%", "")
    a = tonumber(a) and a / 100
  else
    a = tonumber(a)
  end

  if r and g and b and a then
    return { r = r, g = g, b = b, a = a }
  end
end

---@param color Spectrolite.SRGB.RGBA
function M.normalize(color)
  return {
    rn = color.r / 255,
    gn = color.g / 255,
    bn = color.b / 255,
    an = color.a,
  }
end

---@return Spectrolite.SRGB.RGBA
function M.denormalize(normal)
  return {
    r = normal.rn * 255,
    g = normal.gn * 255,
    b = normal.bn * 255,
    a = normal.an,
  }
end

---@param color Spectrolite.SRGB.RGBA
function M.format(color, opts)
  local r, g, b, a = color.r, color.g, color.b, color.a
  local round = require("spectrolite.utils.math").round
  local opt = opts.rgba.round

  if opt then
    r = opt.r and round(r, opt.r) or r
    g = opt.g and round(g, opt.g) or g
    b = opt.b and round(b, opt.b) or b
    a = opt.a and round(a, opt.a) or a
  end

  return { r = r, g = g, b = b, a = a }
end

---@param color Spectrolite.SRGB.RGBA
function M.print(color, opts)
  local alpha = opts.rgba.percents.a and (color.a * 100 .. "%") or color.a

  local sep_regular = opts.rgba.separators.regular or ""
  local sep_alpha = opts.rgba.separators.alpha or ""

  return "rgba("
    .. color.r
    .. sep_regular
    .. color.g
    .. sep_regular
    .. color.b
    .. sep_alpha
    .. alpha
    .. ")"
end

return M
