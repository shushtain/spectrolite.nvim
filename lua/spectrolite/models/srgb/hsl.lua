---@class Spectrolite.SRGB.HSL: Spectrolite.SRGB.Colors
---@field h number Hue [0-360]
---@field s number Saturation [0-100]
---@field l number Lightness [0-100]

---@type Spectrolite.SRGB.Model
local M = {}

function M.parse(str)
  local h, s, l =
    str:match("hsl%s*%(%s*([%d%.]+)[,%s]+([%d%.]+)%%?[,%s]+([%d%.]+)%%?%s*%)")

  h = tonumber(h)
  s = tonumber(s)
  l = tonumber(l)

  if h and s and l then
    return { h = h, s = s, l = l }
  end
end

---@param color Spectrolite.SRGB.HSL
function M.normalize(color)
  local sn = color.s / 100
  local ln = color.l / 100
  local an = 1

  if sn == 0 then
    return { rn = ln, gn = ln, bn = ln, an = an }
  end

  local hn = color.h % 360 / 360

  local p1 = ln < 0.5 and (ln * (1 + sn)) or (ln + sn - ln * sn)
  local p2 = 2 * ln - p1

  local par = {
    rn = (hn + 1 / 3) % 1,
    gn = hn,
    bn = (hn - 1 / 3) % 1,
  }

  for k, pc in pairs(par) do
    if 6 * pc < 1 then
      par[k] = p2 + (p1 - p2) * pc * 6
    elseif 2 * pc < 1 then
      par[k] = p1
    elseif 3 * pc < 2 then
      par[k] = p2 + (p1 - p2) * (2 / 3 - pc) * 6
    else
      par[k] = p2
    end
  end

  return { rn = par.rn, gn = par.gn, bn = par.bn, an = an }
end

---@return Spectrolite.SRGB.HSL
function M.denormalize(normal)
  local rn, gn, bn = normal.rn, normal.gn, normal.bn
  local min, max = math.min(rn, gn, bn), math.max(rn, gn, bn)
  local hn, sn, ln = 0, 0, (max + min) / 2

  if min ~= max then
    if ln <= 0.5 then
      sn = (max - min) / (max + min)
    else
      sn = (max - min) / (2 - max - min)
    end

    if max == rn then
      hn = (gn - bn) / (max - min)
    elseif max == gn then
      hn = 2 + (bn - rn) / (max - min)
    else
      hn = 4 + (rn - gn) / (max - min)
    end
  end

  return {
    h = hn * 60 % 360,
    s = sn * 100,
    l = ln * 100,
  }
end

---@param color Spectrolite.SRGB.HSL
function M.format(color, opts)
  local h, s, l = color.h, color.s, color.l
  local round = require("spectrolite.utils.math").round
  local opt = opts.hsla.round

  if opt then
    h = opt.h and round(h, opt.h) or h
    s = opt.s and round(s, opt.s) or s
    l = opt.l and round(l, opt.l) or l
  end

  return { h = h, s = s, l = l }
end

---@param color Spectrolite.SRGB.HSL
function M.print(color, opts)
  local saturation = color.s .. (opts.hsla.percents.s and "%" or "")
  local lightness = color.l .. (opts.hsla.percents.l and "%" or "")

  local sep_regular = opts.hsla.separators.regular or ""

  return "hsl("
    .. color.h
    .. sep_regular
    .. saturation
    .. sep_regular
    .. lightness
    .. ")"
end

return M
