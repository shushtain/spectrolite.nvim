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
  hex = {
    name = "HEX",
    base = "srgb",
  },
  hexa = {
    name = "HEXA",
    base = "srgb",
  },
  hsl = {
    name = "HSL",
    base = "srgb",
  },
  hsla = {
    name = "HSLA",
    base = "srgb",
  },
  hxl = {
    name = "HXL (Cubehelix)",
    base = "srgb",
  },
  hxla = {
    name = "HXLA (Cubehelix with Alpha)",
    base = "srgb",
  },
  rgb = {
    name = "RGB",
    base = "srgb",
  },
  rgba = {
    name = "RGBA",
    base = "srgb",
  },
}

return M
