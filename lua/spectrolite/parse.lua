-- All conversions happen through RGB(A).
-- Except for HEX, returned values are tables with non-rounded values.
-- HSL is returned as bare degree and percentage values.
-- Alpha is returned as `float` or `nil`.

local convert = require("spectrolite.convert")
local utils = require("spectrolite.utils")
local M = {}

M.auto = function(str)
  str = str:lower()

  if str:match("^#") then
    return convert.from_hex(M.hex(str))
  elseif str:match("^rgb") then
    return M.rgb(str)
  elseif str:match("^hsl") then
    return convert.from_hsl(M.hsl(str))
  elseif str:match("^hxl") then
    return convert.from_hxl(M.hxl(str))
  end

  return nil
end

M.hex = function(str)
  return str:match("#?(.*)")
end

M.rgb = function(str)
  local r, g, b, a = str:match(
    "rgba?%s*%(%s*([%d%.]+)[,%s]+([%d%.]+)[,%s]+([%d%.]+)[/,%s]+([%d%.]+)%s*%)"
  )
  if not a then
    r, g, b =
      str:match("rgb%s*%(%s*([%d%.]+)[,%s]+([%d%.]+)[,%s]+([%d%.]+)%s*%)")
  end

  r = tonumber(r)
  g = tonumber(g)
  b = tonumber(b)
  a = tonumber(a)

  if not r or not g or not b then
    vim.notify("Cannot parse RGB values", vim.log.levels.WARN)
  end

  return { r = r, g = g, b = b, a = a }
end

M.hsl = function(str)
  local h, s, l, a = str:match(
    "hsla?%s*%(%s*([%d%.]+)[,%s]+([%d%.]+)%%?[,%s]+([%d%.]+)%%?[/,%s]+([%d%.]+)%s*%)"
  )
  if not a then
    h, s, l =
      str:match("hsl%s*%(%s*([%d%.]+)[,%s]+([%d%.]+)%%?[,%s]+([%d%.]+)%%?%s*%)")
  end

  h = tonumber(h)
  s = tonumber(s)
  l = tonumber(l)
  a = tonumber(a)

  if not h or not s or not l then
    vim.notify("Cannot parse HSL values", vim.log.levels.WARN)
  end

  return { h = h, s = s, l = l, a = a }
end

M.hxl = function(str)
  local h, x, l, a = str:match(
    "hxla?%s*%(%s*([%d%.]+)[,%s]+([%d%.]+)%%?[,%s]+([%d%.]+)%%?[/,%s]+([%d%.]+)%s*%)"
  )
  if not a then
    h, x, l =
      str:match("hxl%s*%(%s*([%d%.]+)[,%s]+([%d%.]+)%%?[,%s]+([%d%.]+)%%?%s*%)")
  end

  h = tonumber(h)
  x = tonumber(x)
  l = tonumber(l)
  a = tonumber(a)

  if not h or not x or not l then
    vim.notify("Cannot parse HXL values", vim.log.levels.WARN)
  end

  return { h = h, x = x, l = l, a = a }
end

return M
