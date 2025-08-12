---@type Spectrolite.Mode
local M = {}

M.rgba = function(str)
  local r, g, b, a = str:match(
    "rgba?%s*%(%s*([%d%.]+)[,%s]+([%d%.]+)[,%s]+([%d%.]+)[/,%s]+([%d%.]+)%s*%)"
  )

  r = tonumber(r)
  g = tonumber(g)
  b = tonumber(b)
  a = tonumber(a)

  if r and g and b and a then
    return { r = r, g = g, b = b, a = a }
  end

  return nil
end

M.rgb = function(str)
  local r, g, b =
    str:match("rgb%s*%(%s*([%d%.]+)[,%s]+([%d%.]+)[,%s]+([%d%.]+)%s*%)")

  r = tonumber(r)
  g = tonumber(g)
  b = tonumber(b)

  if r and g and b then
    return { r = r, g = g, b = b, a = 1 }
  end

  return nil
end

M.parse = function(str)
  local r, g, b, a = str:match(
    "rgba?%s*%(%s*([%d%.]+)[,%s]+([%d%.]+)[,%s]+([%d%.]+)[/,%s]+([%d%.]+)%s*%)"
  )

  r = tonumber(r)
  g = tonumber(g)
  b = tonumber(b)
  a = tonumber(a)

  if r and g and b and a then
    return M.to_rgba(r, g, b, a)
  end

  return nil
end

M.to_rgba = function(r, g, b, a)
  return { r = r, g = g, b = b, a = a }
end

M.convert = function(r, g, b, a)
  return { r = r, g = g, b = b, a = a }
end

-- FIX:
M.format = function(r, g, b, a)
  if not r or not g or not b then
    vim.notify("Cannot format as RGB", vim.log.levels.WARN)
  end

  r = require("spectrolite.utils").round(r)
  g = require("spectrolite.utils").round(g)
  b = require("spectrolite.utils").round(b)

  if a then
    a = require("spectrolite.utils").round(a, 2)
    return string.format("rgba(%d %d %d / %.2f)", r, g, b, a)
  end

  return string.format("rgb(%d %d %d)", r, g, b)
end

M.round = function(r, g, b, a)
  r = require("spectrolite.utils").round(r)
  g = require("spectrolite.utils").round(g)
  b = require("spectrolite.utils").round(b)
  a = require("spectrolite.utils").round(a, 2)
  return { r, g, b, a }
end
