---@class Spectrolite.Hex
---@field rx string Red Hexadecimal ["00"-"FF"]
---@field gx string Green Hexadecimal ["00"-"FF"]
---@field bx string Blue Hexadecimal ["00"-"FF"]

-- FIX:

---@type Spectrolite.Mode
local M = {}

M.parse = function(str)
  if not str then
    return nil
  end

  local hex = str:match("#(%x+)")
  local rx, gx, bx

  if hex and #hex == 4 then
    rx = hex:sub(1, 1):rep(2)
    gx = hex:sub(2, 2):rep(2)
    bx = hex:sub(3, 3):rep(2)
  end

  if hex and #hex == 8 then
    rx = hex:sub(1, 2)
    gx = hex:sub(3, 4)
    bx = hex:sub(5, 6)
  end

  if rx and gx and bx then
    return M.serialize({ rx = rx, gx = gx, bx = bx })
  end
end

M.serialize = function(clr)
  if not clr.rx or not clr.gx or not clr.bx then
    return nil
  end

  return {
    r = tonumber("0x" .. clr.rx),
    g = tonumber("0x" .. clr.gx),
    b = tonumber("0x" .. clr.bx),
    a = 1,
  }
end

M.convert = function(clr)
  if not clr.r or not clr.g or not clr.b then
    return nil
  end

  local r, g, b = require("spectrolite.modes.rgb").round(clr)

  return {
    rx = ("%02x"):format(r),
    gx = ("%02x"):format(g),
    bx = ("%02x"):format(b),
  }
end

M.format = function(clr)
  if not clr.rx or not clr.gx or not clr.bx then
    return nil
  end

  if require("spectrolite.config").config.lower_hex then
    return "#" .. clr.rx:lower() .. clr.gx:lower() .. clr.bx:lower()
  else
    return "#" .. clr.rx:upper() .. clr.gx:upper() .. clr.bx:upper()
  end
end

M.round = function(clr)
  if not clr.rx or not clr.gx or not clr.bx then
    return nil
  end

  return clr
end
