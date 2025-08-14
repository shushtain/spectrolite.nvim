---@class Spectrolite.Config
---@field hexa? Spectrolite.Config.HEXA Options for HEX(A)
---@field hsla? Spectrolite.Config.HSLA Options for HSL(A)
---@field hxla? Spectrolite.Config.HXLA Options for Cubehelix (with Alpha)
---@field rgba? Spectrolite.Config.RGBA Options for RGB(A)

---@class Spectrolite.Config.HEXA
---@field uppercase? boolean If `true`, uppercase values. Default is `false`

---@class Spectrolite.Config.HSLA
---@field round? Spectrolite.Config.HSLA.Round

---@class Spectrolite.Config.HSLA.Round
---@field h? number If not `nil`, round to `<number>` decimal places. Default is `0`
---@field s? number If not `nil`, round to `<number>` decimal places. Default is `0`
---@field l? number If not `nil`, round to `<number>` decimal places. Default is `0`
---@field a? number If not `nil`, round to `<number>` decimal places. Default is `2`

---@class Spectrolite.Config.HXLA
---@field round? Spectrolite.Config.HXLA.Round

---@class Spectrolite.Config.HXLA.Round
---@field h? number If not `nil`, round to `<number>` decimal places. Default is `0`
---@field x? number If not `nil`, round to `<number>` decimal places. Default is `0`
---@field l? number If not `nil`, round to `<number>` decimal places. Default is `0`
---@field a? number If not `nil`, round to `<number>` decimal places. Default is `2`

---@class Spectrolite.Config.RGBA
---@field round? Spectrolite.Config.RGBA.Round

---@class Spectrolite.Config.RGBA.Round
---@field r? number If not `nil`, round to `<number>` decimal places. Default is `0`
---@field g? number If not `nil`, round to `<number>` decimal places. Default is `0`
---@field b? number If not `nil`, round to `<number>` decimal places. Default is `0`
---@field a? number If not `nil`, round to `<number>` decimal places. Default is `2`

local M = {}

---@type Spectrolite.Config
M.config = {
  hexa = { uppercase = false },
  hsla = { round = { h = 0, s = 0, l = 0, a = 2 } },
  hxla = { round = { h = 0, x = 0, l = 0, a = 2 } },
  rgba = { round = { r = 0, g = 0, b = 0, a = 2 } },
}

---@param opts? Spectrolite.Config
function M.setup(opts)
  M.config = vim.tbl_deep_extend("force", M.config, opts or {})
end

return M
