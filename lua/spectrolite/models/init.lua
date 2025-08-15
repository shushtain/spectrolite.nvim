---@class Spectrolite.Base: Spectrolite
---@field abs fun(normal: Spectrolite.Normals): Spectrolite.Abs

---@class Spectrolite.Abs
---@field l_star number
---@field a_star number
---@field b_star number
---@field alpha number

---@class Spectrolite.Normals
---@class Spectrolite.Colors

---@alias Spectrolite.Bases
---| "srgb" HEX(A), HSL(A), HXL(A), RGB(A)

---@alias Spectrolite.Models
---| Spectrolite.SRGB.Models

local M = {}

M.models = {
  srgb = {
    hex = { name = "HEX" },
    hexa = { name = "HEXA" },
    hsl = { name = "HSL" },
    hsla = { name = "HSLA" },
    hxl = { name = "HXL (Cubehelix)" },
    hxla = { name = "HXLA (Cubehelix with Alpha)" },
    rgb = { name = "RGB" },
    rgba = { name = "RGBA" },
  },
}

return M
