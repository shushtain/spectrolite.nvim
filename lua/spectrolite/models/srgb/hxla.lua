---@class Spectrolite.SRGB.HXLA
---@field h number Hue [0-360]
---@field x number Saturation [0-100+]
---@field l number Lightness [0-100]
---@field a number Alpha [0-1]

local A = -0.14861
local B = 1.78277
local C = -0.29227
local D = -0.90649
local E = 1.97294
local ED = E * D
local EB = E * B
local BC_DA = B * C - D * A

---@type Spectrolite.SRGB.Model
local M = {}

function M.parse(str)
  local h, x, l, a = str:match(
    "hxla%s*%(%s*([%d%.]+)[,%s]+([%d%.]+)%%?[,%s]+([%d%.]+)%%?[/,%s]+([%d%.]+%%?)%s*%)"
  )

  if not a then
    return nil
  end

  h = tonumber(h)
  x = tonumber(x)
  l = tonumber(l)

  if a:match("%%") then
    a = a:gsub("%%", "")
    a = tonumber(a) and a / 100
  else
    a = tonumber(a)
  end

  if h and x and l and a then
    return { h = h, x = x, l = l, a = a }
  end
end

---@param color Spectrolite.SRGB.HXLA
function M.normalize(color)
  local xn = color.x / 100
  local ln = color.l / 100
  local an = color.a

  if ln <= 0 then
    return { rn = 0, gn = 0, bn = 0, an = an }
  end
  if ln >= 1 then
    return { rn = 1, gn = 1, bn = 1, an = an }
  end

  local h = xn <= 0 and 0 or (math.pi * (color.h + 120)) / 180

  local k = xn * ln * (1 - ln)
  local cosh = math.cos(h)
  local sinh = math.sin(h)

  local rn = ln + k * (A * cosh + B * sinh)
  local gn = ln + k * (C * cosh + D * sinh)
  local bn = ln + k * (E * cosh)

  rn = math.min(1, math.max(0, rn))
  gn = math.min(1, math.max(0, gn))
  bn = math.min(1, math.max(0, bn))

  return { rn = rn, gn = gn, bn = bn, an = an }
end

---@return Spectrolite.SRGB.HXLA
function M.denormalize(normal)
  local rn, gn, bn = normal.rn, normal.gn, normal.bn

  local ln = (BC_DA * bn + ED * rn - EB * gn) / (BC_DA + ED - EB)
  local bl = bn - ln
  local k = (E * (gn - ln) - C * bl) / D

  local xn = 0
  if ln > 0 and ln < 1 then
    xn = math.sqrt(k * k + bl * bl) / (E * ln * (1 - ln))
  end

  local h = 0
  if xn > 0 then
    h = math.atan2(k, bl) * (180 / math.pi) - 120
  end

  return {
    h = h % 360,
    x = xn * 100,
    l = ln * 100,
    a = normal.an,
  }
end

---@param color Spectrolite.SRGB.HXLA
function M.format(color, opts)
  local h, x, l, a = color.h, color.x, color.l, color.a
  local round = require("spectrolite.utils.math").round
  local opt = opts.hxla.round

  if opt then
    h = opt.h and round(h, opt.h) or h
    x = opt.x and round(x, opt.x) or x
    l = opt.l and round(l, opt.l) or l
    a = opt.a and round(a, opt.a) or a
  end

  return { h = h, x = x, l = l, a = a }
end

---@param color Spectrolite.SRGB.HXLA
function M.print(color, opts)
  local saturation = color.x .. (opts.hxla.percents.x and "%" or "")
  local lightness = color.l .. (opts.hxla.percents.l and "%" or "")
  local alpha = opts.hxla.percents.a and (color.a * 100 .. "%") or color.a

  local sep_regular = opts.hxla.separators.regular or ""
  local sep_alpha = opts.hxla.separators.alpha or ""

  return "hxla("
    .. color.h
    .. sep_regular
    .. saturation
    .. sep_regular
    .. lightness
    .. sep_alpha
    .. alpha
    .. ")"
end

return M
