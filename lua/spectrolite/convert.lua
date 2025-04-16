-- All conversions happen through RGB(A).
-- Except for HEX, returned values are tables with non-rounded values.
-- HSL is returned as bare degree and percentage values.
-- Alpha is returned as `float` or `nil`.

local utils = require("spectrolite.utils")
local M = {}

M.to_hex = function(r, g, b, a)
  if a then
    return "#" .. string.format("%02x%02x%02x%02x", r, g, b, 255 * a)
  end
  return "#" .. string.format("%02x%02x%02x", r, g, b)
end

M.from_hex = function(hex)
  hex = hex:gsub("#", "")

  if hex:len() == 3 then
    return {
      tonumber("0x" .. hex:sub(1, 1) .. hex:sub(1, 1)),
      tonumber("0x" .. hex:sub(2, 2) .. hex:sub(2, 2)),
      tonumber("0x" .. hex:sub(3, 3) .. hex:sub(3, 3)),
    }
  elseif hex:len() == 4 then
    return {
      tonumber("0x" .. hex:sub(1, 1) .. hex:sub(1, 1)),
      tonumber("0x" .. hex:sub(2, 2) .. hex:sub(2, 2)),
      tonumber("0x" .. hex:sub(3, 3) .. hex:sub(3, 3)),
      tonumber("0x" .. hex:sub(4, 4) .. hex:sub(4, 4)) / 255,
    }
  elseif hex:len() == 6 then
    return {
      tonumber("0x" .. hex:sub(1, 2)),
      tonumber("0x" .. hex:sub(3, 4)),
      tonumber("0x" .. hex:sub(5, 6)),
    }
  elseif hex:len() == 8 then
    return {
      tonumber("0x" .. hex:sub(1, 2)),
      tonumber("0x" .. hex:sub(3, 4)),
      tonumber("0x" .. hex:sub(5, 6)),
      tonumber("0x" .. hex:sub(7, 8)) / 255,
    }
  end
end

M.to_hsl = function(r, g, b, a)
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

  return { h, s * 100, l * 100, a }
end

M.from_hsl = function(h, s, l, a)
  s = s / 100
  l = l / 100

  if s == 0 then
    return { l * 255, l * 255, l * 255, a }
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

  local r = utils.hue_to_rgb(temp1, temp2, tempR)
  local g = utils.hue_to_rgb(temp1, temp2, tempG)
  local b = utils.hue_to_rgb(temp1, temp2, tempB)

  return { r, g, b, a }
end

M.to_hxl = function(r, g, b, a)
  return {}
end

M.from_hxl = function(h, x, l, a)
  return {}
end

return M
