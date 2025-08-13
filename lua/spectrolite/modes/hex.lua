---@class Spectrolite.Hex
---@field rx string Red Hexadecimal ["00"-"FF"]
---@field gx string Green Hexadecimal ["00"-"FF"]
---@field bx string Blue Hexadecimal ["00"-"FF"]

---@type Spectrolite.Mode
local M = {}

function M.parse(str)
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

function M.serialize(clr)
  if not clr then
    return nil
  end

  if not clr.rx or not clr.gx or not clr.bx then
    return nil
  end

  local r = tonumber("0x" .. clr.rx)
  local g = tonumber("0x" .. clr.gx)
  local b = tonumber("0x" .. clr.bx)

  if r and g and b then
    return {
      rc = r / 255,
      gc = g / 255,
      bc = b / 255,
      ac = 1,
    }
  end
end

function M.convert(abs)
  if not abs then
    return nil
  end

  if not abs.rc or not abs.gc or not abs.bc then
    return nil
  end

  local r = require("spectrolite.utils").round(abs.rc * 255)
  local g = require("spectrolite.utils").round(abs.gc * 255)
  local b = require("spectrolite.utils").round(abs.bc * 255)

  if not r or not g or not b then
    return nil
  end

  local rx = ("%02x"):format(r)
  local gx = ("%02x"):format(g)
  local bx = ("%02x"):format(b)

  if require("spectrolite.config").config.convert.upper_hex then
    return {
      rx = rx:upper(),
      gx = gx:upper(),
      bx = bx:upper(),
    }
  else
    return {
      rx = rx:lower(),
      gx = gx:lower(),
      bx = bx:lower(),
    }
  end
end

function M.format(clr)
  if not clr then
    return nil
  end

  if not clr.rx or not clr.gx or not clr.bx then
    return nil
  end

  if require("spectrolite.config").config.format.upper_hex then
    return "#" .. clr.rx:upper() .. clr.gx:upper() .. clr.bx:upper()
  else
    return "#" .. clr.rx:lower() .. clr.gx:lower() .. clr.bx:lower()
  end
end

function M.round(clr)
  if not clr then
    return nil
  end

  if not clr.rx or not clr.gx or not clr.bx then
    return nil
  end

  return clr
end
