---@class Spectrolite.SRGB.Model
---@field pattern string
---@field capture? string
---@field parse fun(str: string): Spectrolite.SRGB.Colors?
---@field normalize fun(color: Spectrolite.SRGB.Colors): Spectrolite.SRGB.Normal
---@field denormalize fun(normal: Spectrolite.SRGB.Normal): Spectrolite.Colors
---@field format fun(color: Spectrolite.SRGB.Colors, opts: Spectrolite.Config): Spectrolite.SRGB.Colors
---@field print fun(color: Spectrolite.SRGB.Colors, opts: Spectrolite.Config): string

---@class Spectrolite.SRGB.Normal
---@field rn number Red Channel [0-1]
---@field gn number Green Channel [0-1]
---@field bn number Blue Channel [0-1]
---@field an number Alpha Channel [0-1]

---@alias Spectrolite.SRGB.Colors
---| Spectrolite.SRGB.HEXA
---| Spectrolite.SRGB.HEX
---| Spectrolite.SRGB.HSLA
---| Spectrolite.SRGB.HSL
---| Spectrolite.SRGB.HXLA
---| Spectrolite.SRGB.HXL
---| Spectrolite.SRGB.RGBA
---| Spectrolite.SRGB.RGB

---@alias Spectrolite.SRGB.Models
---| "hex"  HEX
---| "hexa" HEXA
---| "hsl"  HSL
---| "hsla" HSLA
---| "hxl"  HXL (Cubehelix)
---| "hxla" HXLA (Cubehelix with Alpha)
---| "rgb"  RGB
---| "rgba" RGBA

---@type Spectrolite.Base
local M = {}

-- ---@param normal Spectrolite.SRGB.Normal
-- function M.globalize(normal)
--   local abs = {}
--   -- TODO:
--   vim.notify("Not implemented", vim.log.levels.ERROR)
--   return abs
-- end
--
-- ---@return Spectrolite.SRGB.Normal
-- function M.localize(abs)
--   local normal = {}
--   -- TODO:
--   vim.notify("Not implemented", vim.log.levels.ERROR)
--   return normal
-- end

return M
