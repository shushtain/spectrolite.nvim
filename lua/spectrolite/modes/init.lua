---@class Spectrolite.Mode
---@field parse fun(str: string): Spectrolite.Colors?
---@field normalize fun(clr: Spectrolite.Colors): Spectrolite.Norm
---@field denormalize fun(norm: Spectrolite.Norm): Spectrolite.Colors
---@field format fun(clr: Spectrolite.Colors, opts: Spectrolite.Config): Spectrolite.Colors
---@field print fun(clr: Spectrolite.Colors, opts: Spectrolite.Config): string

local M = {}

---@alias Spectrolite.Colors
---| Spectrolite.Color.HEX
---| Spectrolite.Color.HEXA
---| Spectrolite.Color.HSL
---| Spectrolite.Color.HSLA
---| Spectrolite.Color.HXL
---| Spectrolite.Color.HXLA
---| Spectrolite.Color.RGB
---| Spectrolite.Color.RGBA

---@class Spectrolite.Norm
---@field rn number Red Channel [0-1]
---@field gn number Green Channel [0-1]
---@field bn number Blue Channel [0-1]
---@field an number Alpha Channel [0-1]

---@alias Spectrolite.Modes
---| "hex"  HEX
---| "hexa" HEXA
---| "hsl"  HSL
---| "hsla" HSLA
---| "hxl"  HXL (Cubehelix)
---| "hxla" HXLA (Cubehelix with Alpha)
---| "rgb"  RGB
---| "rgba" RGBA

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

return M
