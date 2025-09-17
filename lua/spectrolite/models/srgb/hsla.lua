---@class Spectrolite.SRGB.HSLA
---@field h number Hue [0-360]
---@field s number Saturation [0-100]
---@field l number Lightness [0-100]
---@field a number Alpha [0-1]

---@type Spectrolite.SRGB.Model
local M = {}

function M.parse(str)
  local h, s, l, a = str:match(
    "hsla%s*%(%s*([%d%.]+)[,%s]+([%d%.]+)%%?[,%s]+([%d%.]+)%%?[/,%s]+([%d%.]+%%?)%s*%)"
  )

  if not a then
    return nil
  end

  h = tonumber(h)
  s = tonumber(s)
  l = tonumber(l)

  if a:match("%%") then
    a = a:gsub("%%", "")
    a = tonumber(a) and a / 100
  else
    a = tonumber(a)
  end

  if h and s and l and a then
    return { h = h, s = s, l = l, a = a }
  end
end

---@param color Spectrolite.SRGB.HSLA
function M.normalize(color)
  local sn = color.s / 100
  local ln = color.l / 100
  local an = color.a

  if ln <= 0 then
    return { rn = 0, gn = 0, bn = 0, an = an }
  end
  if ln >= 1 then
    return { rn = 1, gn = 1, bn = 1, an = an }
  end

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

---@return Spectrolite.SRGB.HSLA
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
    a = normal.an,
  }
end

---@param color Spectrolite.SRGB.HSLA
function M.format(color, opts)
  local h, s, l, a = color.h, color.s, color.l, color.a
  local round = require("spectrolite.utils.math").round
  local opt = opts.hsla.round

  if opt then
    h = opt.h and round(h, opt.h) or h
    s = opt.s and round(s, opt.s) or s
    l = opt.l and round(l, opt.l) or l
    a = opt.a and round(a, opt.a) or a
  end

  return { h = h, s = s, l = l, a = a }
end

---@param color Spectrolite.SRGB.HSLA
function M.print(color, opts)
  local saturation = color.s .. (opts.hsla.percents.s and "%" or "")
  local lightness = color.l .. (opts.hsla.percents.l and "%" or "")
  local alpha = opts.hsla.percents.a and (color.a * 100 .. "%") or color.a

  local sep_regular = opts.hsla.separators.regular or ""
  local sep_alpha = opts.hsla.separators.alpha or ""

  return "hsla("
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
