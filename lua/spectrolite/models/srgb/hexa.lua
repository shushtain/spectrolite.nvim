---@class Spectrolite.SRGB.HEXA
---@field rx string Red Hexadecimal ["%x%x"]
---@field gx string Green Hexadecimal ["%x%x"]
---@field bx string Blue Hexadecimal ["%x%x"]
---@field ax string Alpha Hexadecimal ["%x%x"]

---@type Spectrolite.SRGB.Model
local M = {}
M.pattern = "#?(%x+)"

function M.parse(str)
  local hexa = str:match(M.pattern)
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
    return { rx = rx, gx = gx, bx = bx, ax = ax }
  end
end

---@param color Spectrolite.SRGB.HEXA
function M.normalize(color)
  return {
    rn = tonumber("0x" .. color.rx) / 255,
    gn = tonumber("0x" .. color.gx) / 255,
    bn = tonumber("0x" .. color.bx) / 255,
    an = tonumber("0x" .. color.ax) / 255,
  }
end

---@return Spectrolite.SRGB.HEXA
function M.denormalize(normal)
  local utils = require("spectrolite.utils.math")
  local r = utils.round(normal.rn * 255)
  local g = utils.round(normal.gn * 255)
  local b = utils.round(normal.bn * 255)
  local a = utils.round(normal.an * 255)

  local rx = ("%02x"):format(r)
  local gx = ("%02x"):format(g)
  local bx = ("%02x"):format(b)
  local ax = ("%02x"):format(a)

  return { rx = rx, gx = gx, bx = bx, ax = ax }
end

---@param color Spectrolite.SRGB.HEXA
function M.format(color, opts)
  local rx, gx, bx, ax = color.rx, color.gx, color.bx, color.ax

  if opts.hexa.uppercase then
    rx = rx:upper()
    gx = gx:upper()
    bx = bx:upper()
    ax = ax:upper()
  else
    rx = rx:lower()
    gx = gx:lower()
    bx = bx:lower()
    ax = ax:lower()
  end

  return { rx = rx, gx = gx, bx = bx, ax = ax }
end

---@param color Spectrolite.SRGB.HEXA
function M.print(color, opts)
  local symbol = opts.hexa.symbol and "#" or ""
  return symbol .. color.rx .. color.gx .. color.bx .. color.ax
end

return M
