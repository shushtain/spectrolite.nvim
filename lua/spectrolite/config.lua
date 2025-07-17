---@diagnostic disable: inject-field
---@type Spectrolite.Config
local M = {}

M.defaults = {
  round_hsl = true,
  round_hxl = true,
  lower_hex = false,
}

---@class Spectrolite.Config
---@field round_hsl? boolean Round HSL values to the nearest integer
---@field round_hxl? boolean Round Cubehelix values to the nearest integer
---@field lower_hex? boolean Use lowercase HEX values
M.options = {}

M.__setup = function(options)
  M.options = vim.tbl_deep_extend("force", {}, M.defaults, options or {})
end

return M
