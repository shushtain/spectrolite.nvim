---@class Spectrolite.Hexa
---@field rx string Red Hexadecimal ["00"-"FF"]
---@field gx string Green Hexadecimal ["00"-"FF"]
---@field bx string Blue Hexadecimal ["00"-"FF"]
---@field ax string Alpha Hexadecimal ["00"-"FF"]

---@type Spectrolite.Mode
local M = {}

M.parse = function(str)
  if not str then
    return nil
  end

  local hexa = str:match("#(%x+)")
  local rx, gx, bx, ax

  if hexa and #hexa == 4 then
    rx = hexa:sub(1, 1):rep(2)
    gx = hexa:sub(2, 2):rep(2)
    bx = hexa:sub(3, 3):rep(2)
    ax = hexa:sub(4, 4):rep(2)
  end

  if hexa and #hexa == 8 then
    rx = hexa:sub(1, 2)
    gx = hexa:sub(3, 4)
    bx = hexa:sub(5, 6)
    ax = hexa:sub(7, 8)
  end

  if rx and gx and bx and ax then
    return M.serialize({ rx = rx, gx = gx, bx = bx, ax = ax })
  end
end

M.serialize = function(clr)
  if not clr.rx or not clr.gx or not clr.bx or not clr.ax then
    return nil
  end

  local r = tonumber("0x" .. clr.rx)
  local g = tonumber("0x" .. clr.gx)
  local b = tonumber("0x" .. clr.bx)
  local a = tonumber("0x" .. clr.ax)

  if r and g and b and a then
    return {
      rc = r / 255,
      gc = g / 255,
      bc = b / 255,
      ac = a / 255,
    }
  end
end

M.convert = function(ser)
  if not ser.rc or not ser.gc or not ser.bc or not ser.ac then
    return nil
  end

  local r = require("spectrolite.utils").round(ser.rc * 255)
  local g = require("spectrolite.utils").round(ser.gc * 255)
  local b = require("spectrolite.utils").round(ser.bc * 255)
  local a = require("spectrolite.utils").round(ser.ac * 255)

  if r and g and b and a then
    return {
      rx = ("%02x"):format(r),
      gx = ("%02x"):format(g),
      bx = ("%02x"):format(b),
      ax = ("%02x"):format(a),
    }
  end
end

M.format = function(clr)
  if not clr.rx or not clr.gx or not clr.bx or not clr.ax then
    return nil
  end

  if require("spectrolite.config").config.lower_hex then
    return "#"
      .. clr.rx:lower()
      .. clr.gx:lower()
      .. clr.bx:lower()
      .. clr.ax:lower()
  else
    return "#"
      .. clr.rx:upper()
      .. clr.gx:upper()
      .. clr.bx:upper()
      .. clr.ax:upper()
  end
end

M.round = function(clr)
  if not clr.rx or not clr.gx or not clr.bx or not clr.ax then
    return nil
  end

  return clr
end
