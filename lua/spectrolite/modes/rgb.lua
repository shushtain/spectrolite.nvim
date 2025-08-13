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
    return M.to_rgba({ r = r, g = g, b = b })
  end
end

M.to_rgba = function(clr)
  if not clr.r or not clr.g or not clr.b then
    return nil
  end

  return { r = clr.r, g = clr.g, b = clr.b, a = 1 }
end

M.convert = function(clr)
  if not clr.r or not clr.g or not clr.b then
    return nil
  end

  return clr
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
