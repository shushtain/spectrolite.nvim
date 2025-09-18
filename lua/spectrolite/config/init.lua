---@class Spectrolite.Config
---@field quiet? boolean If `true`, don't emit warnings from functions. Default is `false`
---@field hexa? Spectrolite.Config.HEXA Options for HEX(A)
---@field hsla? Spectrolite.Config.HSLA Options for HSL(A)
---@field hxla? Spectrolite.Config.HXLA Options for Cubehelix (with Alpha)
---@field rgba? Spectrolite.Config.RGBA Options for RGB(A)
---@field highlighter? Spectrolite.Config.Highlighter Options for highlighter

---@class Spectrolite.Config.Highlighter
---@field limit_models? table|false If `false`, all supported models are allowed. If table, limit highlighting to specified models. Default is `false`

---@class Spectrolite.Config.HEXA
---@field uppercase? boolean If `true`, uppercase values. Default is `false`
---@field symbol? boolean If `true`, prefix string with "#". Default is `true`

---@class Spectrolite.Config.HSLA
---@field round? Spectrolite.Config.HSLA.Round
---@field percents? Spectrolite.Config.HSLA.Percents
---@field separators? Spectrolite.Config.Common.Separators

---@class Spectrolite.Config.HSLA.Round
---@field h? number If not `false`, round to `<number>` decimal places. Default is `0`
---@field s? number If not `false`, round to `<number>` decimal places. Default is `0`
---@field l? number If not `false`, round to `<number>` decimal places. Default is `0`
---@field a? number If not `false`, round to `<number>` decimal places. Default is `2`

---@class Spectrolite.Config.HSLA.Percents
---@field s? boolean If `true`, add "%" to value. Default is `false`
---@field l? boolean If `true`, add "%" to value. Default is `false`
---@field a? boolean If `true`, print in percents. Default is `false`

---@class Spectrolite.Config.HXLA
---@field round? Spectrolite.Config.HXLA.Round
---@field percents? Spectrolite.Config.HXLA.Percents
---@field separators? Spectrolite.Config.Common.Separators

---@class Spectrolite.Config.HXLA.Round
---@field h? number If not `false`, round to `<number>` decimal places. Default is `0`
---@field x? number If not `false`, round to `<number>` decimal places. Default is `0`
---@field l? number If not `false`, round to `<number>` decimal places. Default is `0`
---@field a? number If not `false`, round to `<number>` decimal places. Default is `2`

---@class Spectrolite.Config.HXLA.Percents
---@field x? boolean If `true`, add "%" to value. Default is `false`
---@field l? boolean If `true`, add "%" to value. Default is `false`
---@field a? boolean If `true`, print in percents. Default is `false`

---@class Spectrolite.Config.RGBA
---@field round? Spectrolite.Config.RGBA.Round
---@field percents? Spectrolite.Config.RGBA.Percents
---@field separators? Spectrolite.Config.Common.Separators

---@class Spectrolite.Config.RGBA.Round
---@field r? number If not `false`, round to `<number>` decimal places. Default is `0`
---@field g? number If not `false`, round to `<number>` decimal places. Default is `0`
---@field b? number If not `false`, round to `<number>` decimal places. Default is `0`
---@field a? number If not `false`, round to `<number>` decimal places. Default is `2`

---@class Spectrolite.Config.RGBA.Percents
---@field a? boolean If `true`, print in percents. Default is `false`

---@class Spectrolite.Config.Common.Separators
---@field regular string Put between values, except for `alpha`. Default is `" "`
---@field alpha string Put between `alpha` and the rest. Default is `" / "`

local M = {}

---@type Spectrolite.Config
M.config = {
  quiet = false,
  hexa = {
    uppercase = false,
    symbol = true,
  },
  hsla = {
    round = { h = 0, s = 0, l = 0, a = 2 },
    percents = { s = false, l = false, a = false },
    separators = { regular = " ", alpha = " / " },
  },
  hxla = {
    round = { h = 0, x = 0, l = 0, a = 2 },
    percents = { x = false, l = false, a = false },
    separators = { regular = " ", alpha = " / " },
  },
  rgba = {
    round = { r = 0, g = 0, b = 0, a = 2 },
    percents = { a = false },
    separators = { regular = " ", alpha = " / " },
  },
  highlighter = {
    limit_models = false,
  },
}

---@param opts? Spectrolite.Config
function M.setup(opts)
  M.config = vim.tbl_deep_extend("force", M.config, opts or {})
end

return M
