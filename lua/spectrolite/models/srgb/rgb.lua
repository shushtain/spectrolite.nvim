---@class Spectrolite.SRGB.RGB
---@field r number Red [0-255]
---@field g number Green [0-255]
---@field b number Blue [0-255]

---@type Spectrolite.SRGB.Model
local M = {}

function M.parse(str)
  local r, g, b =
    str:match("rgb%s*%(%s*([%d%.]+)[,%s]+([%d%.]+)[,%s]+([%d%.]+)%s*%)")

  r = tonumber(r)
  g = tonumber(g)
  b = tonumber(b)

  if r and g and b then
    r = math.min(255, math.max(0, r))
    g = math.min(255, math.max(0, g))
    b = math.min(255, math.max(0, b))

    return { r = r, g = g, b = b }
  end
end

---@param color Spectrolite.SRGB.RGB
function M.normalize(color)
  return {
    rn = color.r / 255,
    gn = color.g / 255,
    bn = color.b / 255,
    an = 1,
  }
end

---@return Spectrolite.SRGB.RGB
function M.denormalize(normal)
  return {
    r = normal.rn * 255,
    g = normal.gn * 255,
    b = normal.bn * 255,
  }
end

---@param color Spectrolite.SRGB.RGB
function M.format(color, opts)
  local r, g, b = color.r, color.g, color.b
  local round = require("spectrolite.utils.math").round
  local opt = opts.rgba.round

  if opt then
    r = opt.r and round(r, opt.r) or r
    g = opt.g and round(g, opt.g) or g
    b = opt.b and round(b, opt.b) or b
  end

  return { r = r, g = g, b = b }
end

---@param color Spectrolite.SRGB.RGB
function M.print(color, opts)
  local sep_regular = opts.rgba.separators.regular or ""
  return "rgb("
    .. color.r
    .. sep_regular
    .. color.g
    .. sep_regular
    .. color.b
    .. ")"
end

return M
