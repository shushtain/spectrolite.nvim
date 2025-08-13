---@class Spectrolite.Mode
---@field parse fun(str: string): Spectrolite.Abs|nil Parse string to RGBA coordinates
---@field serialize fun(clr: Spectrolite.Color):  Spectrolite.Abs|nil Convert to RGBA coordinates
---@field convert fun(abs: Spectrolite.Abs): Spectrolite.Color|nil Convert to local coordinates
---@field format fun(clr: Spectrolite.Color): string|nil Format coordinates into string
---@field round fun(clr: Spectrolite.Color): Spectrolite.Color|nil Round coordinates

---@alias Spectrolite.Color Spectrolite.Rgba | Spectrolite.Rgb | Spectrolite.Hexa | Spectrolite.Hex | Spectrolite.Hsla

---@class Spectrolite.Abs
---@field rc number Red Channel [0-1]
---@field gc number Green Channel [0-1]
---@field bc number Blue Channel [0-1]
---@field ac number Alpha Channel [0-1]

-- TODO: Store all values as 0-1 instead of 0-255/0-1

---@class Spectrolite.Modes
---@field modes table All supported modes
---@field parse fun(str: string): Spectrolite.Abs|nil Parse string to RGBA coordinates
---@field convert fun(mode: string, abs: Spectrolite.Abs): Spectrolite.Color|nil Convert to local coordinates
---@field format fun(mode: string, clr: Spectrolite.Color): string|nil Format coordinates into string
---@field round fun(mode: string, clr: Spectrolite.Color): Spectrolite.Color|nil Round coordinates
local M = {}

M.modes = {
  hex = { name = "HEX" },
  hexa = { name = "HEXA" },
  hsl = { name = "HSL" },
  hsla = { name = "HSLA" },
  hxl = { name = "HXL (Cubehelix)" },
  hxla = { name = "HXLA (Cubehelix with Alpha)" },
  rgb = { name = "RGB" },
  rgba = { name = "RGBA" },
}

M.parse = function(str)
  if not str then
    return nil
  end

  str = str:lower()

  return require("spectrolite.modes.hexa").parse(str)
    or require("spectrolite.modes.hex").parse(str)
    or require("spectrolite.modes._rgba").parse(str)
    or require("spectrolite.modes.rgb").parse(str)
    or require("spectrolite.modes._hsla").parse(str)
    or require("spectrolite.modes.hsl").parse(str)
    or require("spectrolite.modes._hxla").parse(str)
    or require("spectrolite.modes.hxl").parse(str)
end

M.convert = function(mode, abs)
  if not mode or not abs then
    return nil
  end

  return require("spectrolite.modes." .. mode).convert(abs)
end

M.format = function(mode, clr)
  if not mode or not clr then
    return nil
  end

  return require("spectrolite.modes." .. mode).format(clr)
end

M.round = function(mode, clr)
  if not mode or not clr then
    return nil
  end

  return require("spectrolite.modes." .. mode).round(clr)
end

return M
