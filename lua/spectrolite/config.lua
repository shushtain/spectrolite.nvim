---@class ConfigModule
---@field defaults Config: default options.
---@field options Config: config table.
local M = {}

M.defaults = {
  round_hsl = true,
  round_hxl = true,
  lower_hex = false,
}

---@class Config
---@field round_hsl boolean: round HSL values to the nearest integer.
---@field round_hxl boolean: round Cubehelix values to the nearest integer.
---@field lower_hex boolean: use lowercase HEX values.
M.options = {}

---@param options Config: user config.
M.__setup = function(options)
  M.options = vim.tbl_deep_extend("force", {}, M.defaults, options or {})
end

return M
