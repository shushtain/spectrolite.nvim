---@type Spectrolite.Mode
local M = {}

local A = -0.14861
local B = 1.78277
local C = -0.29227
local D = -0.90649
local E = 1.97294
local ED = E * D
local EB = E * B
local BC_DA = B * C - D * A

M.hxla = function(str)
  local h, x, l, a = str:match(
    "hxla?%s*%(%s*([%d%.]+)[,%s]+([%d%.]+)%%?[,%s]+([%d%.]+)%%?[/,%s]+([%d%.]+%%?)%s*%)"
  )

  if a:match("%%") then
    a = a:gsub("%%", "")
    a = tonumber(a) and a / 100
  else
    a = tonumber(a)
  end

  h = tonumber(h)
  x = tonumber(x)
  l = tonumber(l)

  if h and x and l and a then
    return require("spectrolite.modes.convert").from_hxla(h, x, l, a)
  end

  return nil
end

M.hxl = function(str)
  local h, x, l =
    str:match("hxl%s*%(%s*([%d%.]+)[,%s]+([%d%.]+)%%?[,%s]+([%d%.]+)%%?%s*%)")

  h = tonumber(h)
  x = tonumber(x)
  l = tonumber(l)

  if h and x and l then
    return require("spectrolite.modes.convert").from_hxla(h, x, l, 1)
  end

  return nil
end
M.parse = function(str)
  return nil
end

M.to_hxla = function(r, g, b, a)
  local h, x, l = M.to_hxl(r, g, b)
  return { h = h, x = x, l = l, a = a }
end

M.to_hxl = function(r, g, b)
  r = r / 255
  g = g / 255
  b = b / 255

  local l = (BC_DA * b + ED * r - EB * g) / (BC_DA + ED - EB)
  local bl = b - l
  local k = (E * (g - l) - C * bl) / D

  local x = 0
  if l > 0 and l < 1 then
    x = math.sqrt(k * k + bl * bl) / (E * l * (1 - l))
  end

  local h = 0
  if x > 0 then
    h = math.atan2(k, bl) * (180 / math.pi) - 120
  end

  h = h % 360
  x = x * 100
  l = l * 100

  return { h = h, x = x, l = l }
end

M.from_hxl = function(h, x, l, a)
  x = x / 100
  l = l / 100

  if l <= 0 then
    return { r = 0, g = 0, b = 0, a = a }
  end
  if l >= 1 then
    return { r = 255, g = 255, b = 255, a = a }
  end

  h = (math.pi * (h + 120)) / 180

  if x <= 0 then
    h = 0
  end

  local k = x * l * (1 - l)
  local cosh = math.cos(h)
  local sinh = math.sin(h)

  local r = l + k * (A * cosh + B * sinh)
  local g = l + k * (C * cosh + D * sinh)
  local b = l + k * (E * cosh)

  r = math.min(1, math.max(0, r))
  g = math.min(1, math.max(0, g))
  b = math.min(1, math.max(0, b))

  return { r = r * 255, g = g * 255, b = b * 255, a = a }
end

M.to_rgba = function(coords)
  return nil
end

M.convert = function(r, g, b, a)
  return nil
end

M.hxl = function(color)
  local h, x, l, a = color.h, color.x, color.l, color.a
  if not h or not x or not l then
    vim.notify("Cannot format as Cubehelix", vim.log.levels.WARN)
  end

  local round = require("spectrolite.config").options.round_hxl
  local points = round and 0 or 2
  h = require("spectrolite.utils").round(h, points)
  x = require("spectrolite.utils").round(x, points)
  if x == 0 then
    h = 0
  end
  l = require("spectrolite.utils").round(l, points)

  if a then
    a = require("spectrolite.utils").round(a, 2)
    if round then
      return string.format("hxla(%d %d%% %d%% / %.2f)", h, x, l, a)
    end
    return string.format("hxla(%.2f %.2f%% %.2f%% / %.2f)", h, x, l, a)
  end

  if round then
    return string.format("hxl(%d %d%% %d%%)", h, x, l)
  end
  return string.format("hxl(%.2f %.2f%% %.2f%%)", h, x, l)
end
M.format = function(hex_a)
  return ""
end

M.round = function(h, x, l, a)
  h = require("spectrolite.utils").round(h)
  x = require("spectrolite.utils").round(x)
  l = require("spectrolite.utils").round(l)
  a = require("spectrolite.utils").round(a, 2)
  return { h, x, l, a }
end
