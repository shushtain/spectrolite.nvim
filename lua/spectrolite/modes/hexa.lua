---@type Spectrolite.Mode
local M = {}

M.parse = function(str)
  local hex_a = str:match("#(%x+)")
  if hex_a then
    return M.to_rgba(hex_a)
  end
  return nil
end

M.to_hexa = function(r, g, b, a)
  return "#" .. string.format("%02x%02x%02x%02x", r, g, b, 255 * a)
end

M.to_hex = function(r, g, b)
  return "#" .. string.format("%02x%02x%02x", r, g, b)
end

M.from_hexa = function(hexa)
  hexa = hexa:gsub("#", "")

  if hexa:len() == 3 then
    local r, g, b = hexa:sub(1, 1), hexa:sub(2, 2), hexa:sub(3, 3)
    return {
      r = tonumber("0x" .. r .. r),
      g = tonumber("0x" .. g .. g),
      b = tonumber("0x" .. b .. b),
    }
  end

  if hexa:len() == 4 then
    local r, g, b, a =
      hexa:sub(1, 1), hexa:sub(2, 2), hexa:sub(3, 3), hexa:sub(4, 4)
    return {
      r = tonumber("0x" .. r .. r),
      g = tonumber("0x" .. g .. g),
      b = tonumber("0x" .. b .. b),
      a = tonumber("0x" .. a .. a) / 255,
    }
  end

  if hexa:len() == 6 then
    local r, g, b = hexa:sub(1, 2), hexa:sub(3, 4), hexa:sub(5, 6)
    return {
      r = tonumber("0x" .. r .. r),
      g = tonumber("0x" .. g .. g),
      b = tonumber("0x" .. b .. b),
    }
  end

  if hexa:len() == 8 then
    local r, g, b, a =
      hexa:sub(1, 2), hexa:sub(3, 4), hexa:sub(5, 6), hexa:sub(7, 8)
    return {
      r = tonumber("0x" .. r .. r),
      g = tonumber("0x" .. g .. g),
      b = tonumber("0x" .. b .. b),
      a = tonumber("0x" .. a .. a) / 255,
    }
  end
end

M.to_rgba = function(coords)
  return nil
end

M.convert = function(r, g, b, a)
  return nil
end

-- FIX:
M.format = function(hex_a)
  if not hex_a then
    vim.notify("Cannot format as HEX", vim.log.levels.WARN)
  end

  local lower_hex = require("spectrolite.config").options.lower_hex
  return lower_hex and hex_a:lower() or hex_a:upper()
end

M.round = function(hex_a)
  return hex_a
end
