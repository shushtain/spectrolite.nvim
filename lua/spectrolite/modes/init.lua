---@class Spectrolite.Mode
---@field parse fun(str: string): Spectrolite.Abs?, string? Parse string to RGBA coordinates
---@field serialize fun(clr: Spectrolite.Color):  Spectrolite.Abs? Convert to RGBA coordinates
---@field convert fun(abs: Spectrolite.Abs, opts?: Spectrolite.Config): Spectrolite.Color? Convert to local coordinates
---@field format fun(clr: Spectrolite.Color, opts?: Spectrolite.Config): string? Format coordinates into string
---@field round fun(clr: Spectrolite.Color, precision?: number): Spectrolite.Color? Round coordinates to `precision`. Alpha is often rounded independently

---@alias Spectrolite.Color Spectrolite.Rgba | Spectrolite.Rgb | Spectrolite.Hexa | Spectrolite.Hex | Spectrolite.Hsla

---@class Spectrolite.Abs
---@field rc number Red Channel [0-1]
---@field gc number Green Channel [0-1]
---@field bc number Blue Channel [0-1]
---@field ac number Alpha Channel [0-1]

---@class Spectrolite.Modes
---@field modes table All supported modes
---@field parse fun(str: string, mode_forced?: string): Spectrolite.Abs?, string? Parse string to RGBA coordinates
---@field convert fun(mode: string, abs: Spectrolite.Abs, opts?: Spectrolite.Config): Spectrolite.Color? Convert to local coordinates
---@field format fun(mode: string, clr: Spectrolite.Color, opts?: Spectrolite.Config): string? Format coordinates into string
local M = {}

M.modes = {
  hex = { name = "HEX" },
  hexa = { name = "HEXA" },
  hsl = { name = "HSL" },
  hsla = { name = "HSLA" },
  hxl = { name = "HXL (Cubehelix)" },
  hxla = { name = "HXLA (Cubehelix with Alpha)" },
  rgb = { name = "RGB" },
  rgba = { name = "RGBA" },
}

function M.parse(str, mode_forced)
  if not str then
    return nil
  end

  str = str:lower()

  if mode_forced then
    return require("spectrolite.modes." .. mode_forced).parse(str)
  end

  local result, mode_auto

  for mode in vim.tbl_keys(M.modes) do
    result, mode_auto = require("spectrolite.modes." .. mode).parse(str)
    if result then
      return result, mode_auto
    end
  end
end

function M.convert(mode, abs, opts)
  if not mode or not abs then
    return nil
  end

  return require("spectrolite.modes." .. mode).convert(abs, opts)
end

function M.format(mode, clr, opts)
  if not mode or not clr then
    return nil
  end

  return require("spectrolite.modes." .. mode).format(clr, opts)
end

return M
