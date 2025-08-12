---@class Spectrolite.Config
---@field round_hsl? boolean If `true`, round HSL values to the nearest integer. Default is `true`
---@field round_hxl? boolean If `true`, round Cubehelix values to the nearest integer. Default is `true`
---@field lower_hex? boolean If true, use lowercase HEX values. Default is false

local M = {}

---@type Spectrolite.Config
M.config = {
  round_hsl = true,
  round_hxl = true,
  lower_hex = false,
}

---@param opts? Spectrolite.Config
M.setup = function(opts)
  M.config = vim.tbl_deep_extend("force", M.config, opts or {})
end

return M
