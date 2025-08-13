---@type Spectrolite.Mode
local M = {}

M.hsla = function(str)
  local h, s, l, a = str:match(
    "hsla?%s*%(%s*([%d%.]+)[,%s]+([%d%.]+)%%?[,%s]+([%d%.]+)%%?[/,%s]+([%d%.]+%%?)%s*%)"
  )

  if a:match("%%") then
    a = a:gsub("%%", "")
    a = tonumber(a) and a / 100
  else
    a = tonumber(a)
  end

  h = tonumber(h)
  s = tonumber(s)
  l = tonumber(l)

  if h and s and l and a then
    return require("spectrolite.modes.convert").from_hsla(h, s, l, a)
  end

  return nil
end

M.hsl = function(str)
  local h, s, l =
    str:match("hsl%s*%(%s*([%d%.]+)[,%s]+([%d%.]+)%%?[,%s]+([%d%.]+)%%?%s*%)")

  h = tonumber(h)
  s = tonumber(s)
  l = tonumber(l)

  if h and s and l then
    return require("spectrolite.modes.convert").from_hsla(h, s, l, 1)
  end

  return nil
end

M.parse = function(str)
  return nil
end

M.to_hsla = function(r, g, b, a)
  local h, s, l = M.to_hsl(r, g, b)
  return { h = h, s = s, l = l, a = a }
end

M.to_hsl = function(r, g, b)
  r = r / 255
  g = g / 255
  b = b / 255

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

  return { h = h, s = s * 100, l = l * 100 }
end

M.from_hsla = function(h, s, l, a)
  s = s / 100
  l = l / 100

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

  local r = require("spectrolite.utils").hue_to_rgb(temp1, temp2, tempR)
  local g = require("spectrolite.utils").hue_to_rgb(temp1, temp2, tempG)
  local b = require("spectrolite.utils").hue_to_rgb(temp1, temp2, tempB)

  return { r = r * 255, g = g * 255, b = b * 255, a = a }
end

M.serialize = function(coords)
  return nil
end

M.convert = function(r, g, b, a)
  return nil
end

M.hsl = function(color)
  local h, s, l, a = color.h, color.s, color.l, color.a
  if not h or not s or not l then
    vim.notify("Cannot format as HSL", vim.log.levels.WARN)
  end

  local round = require("spectrolite.config").options.round_hsl
  local points = round and 0 or 2
  h = require("spectrolite.utils").round(h, points)
  s = require("spectrolite.utils").round(s, points)
  l = require("spectrolite.utils").round(l, points)

  if a then
    a = require("spectrolite.utils").round(a, 2)
    if round then
      return string.format("hsla(%d %d%% %d%% / %.2f)", h, s, l, a)
    end
    return string.format("hsla(%.2f %.2f%% %.2f%% / %.2f)", h, s, l, a)
  end

  if round then
    return string.format("hsl(%d %d%% %d%%)", h, s, l)
  end
  return string.format("hsl(%.2f %.2f%% %.2f%%)", h, s, l)
end

M.format = function(hex_a)
  return ""
end

M.round = function(h, s, l, a)
  h = require("spectrolite.utils").round(h)
  s = require("spectrolite.utils").round(s)
  l = require("spectrolite.utils").round(l)
  a = require("spectrolite.utils").round(a, 2)
  return { h, s, l, a }
end
