---@class Spectrolite.Rgb
---@field r number Red [0-255]
---@field g number Green [0-255]
---@field b number Blue [0-255]

-- FIX:

---@type Spectrolite.Mode
local M = {}

M.parse = function(str)
  if not str then
    return nil
  end

  local r, g, b =
    str:match("rgb%s*%(%s*([%d%.]+)[,%s]+([%d%.]+)[,%s]+([%d%.]+)%s*%)")

  r = tonumber(r)
  g = tonumber(g)
  b = tonumber(b)

  if r and g and b then
    return M.serialize({ r = r, g = g, b = b })
  end
end

M.serialize = function(clr)
  if not clr.r or not clr.g or not clr.b then
    return nil
  end

  return {
    rc = clr.r / 255,
    gc = clr.g / 255,
    bc = clr.b / 255,
    ac = 1,
  }
end

M.convert = function(ser)
  if not ser.rc or not ser.gc or not ser.bc then
    return nil
  end

  return {
    r = ser.rc * 255,
    g = ser.gc * 255,
    b = ser.bc * 255,
  }
end

M.format = function(clr)
  if not clr.r or not clr.g or not clr.b then
    return nil
  end

  local r, g, b = M.round(clr)
  return ("rgba(%d %d %d)"):format(r, g, b)
end

M.round = function(clr)
  if not clr.r or not clr.g or not clr.b then
    return nil
  end

  return {
    r = require("spectrolite.utils").round(clr.r),
    g = require("spectrolite.utils").round(clr.g),
    b = require("spectrolite.utils").round(clr.b),
  }
end
