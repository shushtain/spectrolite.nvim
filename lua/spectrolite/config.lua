---@class Spectrolite.Config
---@field round_hsl? boolean If `true`, round HSL(A) values. Default is `true`
---@field round_hxl? boolean If `true`, round HXL(A) values. Default is `true`
---@field round_rgb? boolean If `true`, round RGB(A) values. Default is `true`
---@field upper_hex? boolean If `true`, uppercase HEX(A) values. Default is `true`

local M = {}

---@type Spectrolite.Config
M.config = {
  round_hsl = true,
  round_hxl = true,
  round_rgb = true,
  upper_hex = true,
}

---@param opts? Spectrolite.Config
function M.setup(opts)
  M.config = vim.tbl_deep_extend("force", M.config, opts or {})
end

return M
