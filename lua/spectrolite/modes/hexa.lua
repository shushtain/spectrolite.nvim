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
    return M.to_rgba({ rx = rx, gx = gx, bx = bx, ax = ax })
  end
end

M.to_rgba = function(clr)
  if not clr.rx or not clr.gx or not clr.bx or not clr.ax then
    return nil
  end

  return {
    r = tonumber("0x" .. clr.rx),
    g = tonumber("0x" .. clr.gx),
    b = tonumber("0x" .. clr.bx),
    a = tonumber("0x" .. clr.ax) / 255,
  }
end

M.convert = function(clr)
  if not clr.r or not clr.g or not clr.b or not clr.a then
    return nil
  end

  local r, g, b, a = require("spectrolite.modes.rgba").round(clr)

  return {
    rx = ("%02x"):format(r),
    gx = ("%02x"):format(g),
    bx = ("%02x"):format(b),
    ax = ("%02x"):format(a * 255),
  }
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
