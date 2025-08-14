---@class Spectrolite.Color.RGB
---@field r number Red [0-255]
---@field g number Green [0-255]
---@field b number Blue [0-255]

---@type Spectrolite.Mode
local M = {}

function M.parse(str)
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

function M.serialize(clr)
  if not clr then
    return nil
  end

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

function M.convert(abs)
  if not abs then
    return nil
  end

  if not abs.rc or not abs.gc or not abs.bc then
    return nil
  end

  local clr = {
    r = abs.rc * 255,
    g = abs.gc * 255,
    b = abs.bc * 255,
  }

  if require("spectrolite.config").config.convert.round_rgb then
    return M.round(clr)
  end

  return clr
end

function M.format(clr)
  if not clr then
    return nil
  end

  if not clr.r or not clr.g or not clr.b then
    return nil
  end

  if
    require("spectrolite.config").config.format.round_rgb
    or require("spectrolite.config").config.convert.round_rgb
  then
    local out = M.round(clr)
    return out and ("rgba(%d %d %d)"):format(out.r, out.g, out.b)
  else
    local out = M.round(clr, 2)
    return out and ("rgba(%.2f %.2f %.2f)"):format(out.r, out.g, out.b)
  end
end

function M.round(clr, precision)
  if not clr then
    return nil
  end

  if not clr.r or not clr.g or not clr.b then
    return nil
  end

  return {
    r = require("spectrolite.utils").round(clr.r, precision),
    g = require("spectrolite.utils").round(clr.g, precision),
    b = require("spectrolite.utils").round(clr.b, precision),
  }
end
