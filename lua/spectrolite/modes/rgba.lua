---@class Spectrolite.Rgba
---@field r number Red [0-255]
---@field g number Green [0-255]
---@field b number Blue [0-255]
---@field a number Alpha [0-255]

-- FIX:

---@type Spectrolite.Mode
local M = {}

M.parse = function(str)
  if not str then
    return nil
  end

  local r, g, b, a = str:match(
    "rgba?%s*%(%s*([%d%.]+)[,%s]+([%d%.]+)[,%s]+([%d%.]+)[/,%s]+([%d%.]+)%s*%)"
  )

  r = tonumber(r)
  g = tonumber(g)
  b = tonumber(b)
  a = tonumber(a)

  if r and g and b and a then
    a = math.min(a, 1)
    return M.serialize({ r = r, g = g, b = b, a = a })
  end
end

M.serialize = function(clr)
  if not clr.r or not clr.g or not clr.b or not clr.a then
    return nil
  end

  return {
    rc = clr.r / 255,
    gc = clr.g / 255,
    bc = clr.b / 255,
    ac = clr.a,
  }
end

M.convert = function(ser)
  if not ser.rc or not ser.gc or not ser.bc or not ser.ac then
    return nil
  end

  return {
    r = ser.rc * 255,
    g = ser.gc * 255,
    b = ser.bc * 255,
    a = ser.ac,
  }
end

M.format = function(clr)
  if not clr.r or not clr.g or not clr.b or not clr.a then
    return nil
  end

  local r, g, b, a = M.round(clr)
  return ("rgba(%d %d %d / %.2f)"):format(r, g, b, a)
end

M.round = function(clr)
  if not clr.r or not clr.g or not clr.b or not clr.a then
    return nil
  end

  return {
    r = require("spectrolite.utils").round(clr.r),
    g = require("spectrolite.utils").round(clr.g),
    b = require("spectrolite.utils").round(clr.b),
    a = require("spectrolite.utils").round(clr.a, 2),
  }
end
