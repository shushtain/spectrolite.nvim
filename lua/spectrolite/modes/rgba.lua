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
    return M.to_rgba({ r = r, g = g, b = b, a = a })
  end
end

M.to_rgba = function(clr)
  if not clr.r or not clr.g or not clr.b or not clr.a then
    return nil
  end

  return clr
end

M.convert = function(clr)
  if not clr.r or not clr.g or not clr.b or not clr.a then
    return nil
  end

  return clr
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
