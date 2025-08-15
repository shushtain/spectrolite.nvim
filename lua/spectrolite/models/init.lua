---@class Spectrolite.Base
---@field globalize fun(normal: Spectrolite.Normals): Spectrolite.Abs
---@field localize fun(abs: Spectrolite.Abs): Spectrolite.Normals

---@class Spectrolite.Abs
---@field l_star number L* Coordinate [CIELAB]
---@field a_star number a* Coordinate [CIELAB]
---@field b_star number b* Coordinate [CIELAB]
---@field alpha number Alpha channel [0-1]

---@class Spectrolite.Normals
---@class Spectrolite.Colors

---@alias Spectrolite.Models
---| Spectrolite.SRGB.Models

---@alias Spectrolite.Bases
---| "srgb" HEX(A), HSL(A), HXL(A), RGB(A)

local M = {}

M.models = {
  hex = { base = "srgb", name = "HEX" },
  hexa = { base = "srgb", name = "HEXA" },
  hsl = { base = "srgb", name = "HSL" },
  hsla = { base = "srgb", name = "HSLA" },
  hxl = { base = "srgb", name = "HXL (Cubehelix)" },
  hxla = { base = "srgb", name = "HXLA (Cubehelix with Alpha)" },
  rgb = { base = "srgb", name = "RGB" },
  rgba = { base = "srgb", name = "RGBA" },
}

return M
