---@class Spectrolite.Color.HEX
---@field rx string Red Hexadecimal ["00"-"FF"]
---@field gx string Green Hexadecimal ["00"-"FF"]
---@field bx string Blue Hexadecimal ["00"-"FF"]

---@type Spectrolite.Mode
local M = {}

function M.parse(str)
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
    return { rx = rx, gx = gx, bx = bx }
  end
end

function M.normalize(clr)
  local r = tonumber("0x" .. clr.rx)
  local g = tonumber("0x" .. clr.gx)
  local b = tonumber("0x" .. clr.bx)

  return {
    rc = r / 255,
    gc = g / 255,
    bc = b / 255,
    ac = 1,
  }
end

function M.denormalize(norm)
  local utils = require("spectrolite.utils")
  local r = utils.round(norm.rn * 255)
  local g = utils.round(norm.gn * 255)
  local b = utils.round(norm.bn * 255)

  local rx = ("%02x"):format(r)
  local gx = ("%02x"):format(g)
  local bx = ("%02x"):format(b)

  return { rx = rx, gx = gx, bx = bx }
end

function M.format(clr, opts)
  local rx, gx, bx = clr.rx, clr.gx, clr.bx

  if opts.hexa.uppercase then
    rx = rx:upper()
    gx = gx:upper()
    bx = bx:upper()
  else
    rx = rx:lower()
    gx = gx:lower()
    bx = bx:lower()
  end

  return { rx = rx, gx = gx, bx = bx }
end

function M.print(clr)
  return "#" .. clr.rx .. clr.gx .. clr.bx
end

return M
