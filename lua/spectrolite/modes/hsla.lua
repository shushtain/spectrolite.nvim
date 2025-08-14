---@class Spectrolite.Color.HSLA
---@field h number Hue [0-360]
---@field s number Saturation [0-100]
---@field l number Lightness [0-100]
---@field a number Alpha [0-1]

-- FIX:

---@type Spectrolite.Mode
local M = {}

function M.parse(str)
  if not str then
    return nil
  end

  local h, s, l, a = str:match(
    "hsla?%s*%(%s*([%d%.]+)[,%s]+([%d%.]+)%%?[,%s]+([%d%.]+)%%?[/,%s]+([%d%.]+%%?)%s*%)"
  )

  if not h or not s or not l or not a then
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
    return M.serialize({ h = h, s = s, l = l, a = a })
  end
end

function M.serialize(clr)
  if not clr.h or not clr.s or not clr.l or not clr.a then
    return nil
  end

  local h = clr.h
  local s = clr.s / 100
  local l = clr.l / 100
  local a = clr.a

  if s == 0 then
    return { r = l * 255, g = l * 255, b = l * 255, a = a }
  end

  local temp1, temp2, tempR, tempG, tempB

  if l < 0.5 then
    temp1 = l * (1 + s)
  else
    temp1 = l + s - l * s
  end

  temp2 = 2 * l - temp1

  h = h % 360
  h = h / 360

  tempR = (h + 1 / 3) % 1
  tempG = h
  tempB = (h - 1 / 3) % 1

  local function hue_to_rgb(t1, t2, tc)
    if 6 * tc < 1 then
      return t2 + (t1 - t2) * tc * 6
    elseif 2 * tc < 1 then
      return t1
    elseif 3 * tc < 2 then
      return t2 + (t1 - t2) * (2 / 3 - tc) * 6
    else
      return t2
    end
  end

  local r = hue_to_rgb(temp1, temp2, tempR)
  local g = hue_to_rgb(temp1, temp2, tempG)
  local b = hue_to_rgb(temp1, temp2, tempB)

  if r and g and b and a then
    return { r = r * 255, g = g * 255, b = b * 255, a = a }
  end
end

function M.convert(clr)
  if not clr.r or not clr.g or not clr.b or not clr.a then
    return nil
  end

  local r = clr.r / 255
  local g = clr.g / 255
  local b = clr.b / 255
  local a = clr.a

  local max = math.max(r, g, b)
  local min = math.min(r, g, b)

  local h = 0
  local s = 0
  local l = (max + min) / 2

  if min ~= max then
    if l <= 0.5 then
      s = (max - min) / (max + min)
    else
      s = (max - min) / (2 - max - min)
    end

    if max == r then
      h = (g - b) / (max - min)
    elseif max == g then
      h = 2 + (b - r) / (max - min)
    else
      h = 4 + (r - g) / (max - min)
    end

    h = h * 60
    h = h % 360
  end

  if h and s and l and a then
    return { h = h, s = s * 100, l = l * 100, a = a }
  end
end

function M.format(clr)
  if not clr.h or not clr.s or not clr.l or not clr.a then
    return nil
  end

  if require("spectrolite.config").config.format.round_hsl then
    local h, s, l, a = M.round(clr)
    return ("hsla(%d %d%% %d%% / %.2f)"):format(h, s, l, a)
  else
    local h, s, l, a = clr.h, clr.s, clr.l, clr.a
    return ("hsla(%.2f %.2f%% %.2f%% / %.2f)"):format(h, s, l, a)
  end
end

function M.round(clr)
  if not clr.h or not clr.s or not clr.l or not clr.a then
    return nil
  end

  return {
    h = require("spectrolite.utils").round(clr.h),
    s = require("spectrolite.utils").round(clr.s),
    l = require("spectrolite.utils").round(clr.l),
    a = require("spectrolite.utils").round(clr.a, 2),
  }
end
