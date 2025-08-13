---@class Spectrolite.Mode
---@field parse fun(str: string): { r: number, g: number, b: number, a: number } | nil Parse to RGBA coordinates
---@field to_rgba fun(clr: table): { r: number, g: number, b: number, a: number } | nil Convert to RGBA coordinates
---@field convert fun(clr: {r: number, g:number, b:number, a:number}): table|nil Convert to local coordinates
---@field format fun(clr:table): string|nil Format coordinates into string
---@field round fun(clr: table): table|nil Round coordinates

-- TODO: Store all values as 0-1 instead of 0-255/0-1

local M = {}

M.modes = {
  hex = { repr = "HEX", group = "hex" },
  hexa = { repr = "HEXA", group = "hexa" },
  hsl = { repr = "HSL", group = "hsl" },
  hsla = { repr = "HSLA", group = "hsla" },
  hxl = { repr = "HXL (Cubehelix)", group = "hxl" },
  hxla = { repr = "HXLA (Cubehelix with Alpha)", group = "hxla" },
  rgb = { repr = "RGB", group = "rgb" },
  rgba = { repr = "RGBA", group = "rgba" },
}

M.parse = function(str)
  if not str then
    return nil
  end

  str = str:lower()
  return require("spectrolite.modes.hexa").parse(str)
    or require("spectrolite.modes.hex").parse(str)
    or require("spectrolite.modes._rgba").parse(str)
    or require("spectrolite.modes.rgb").parse(str)
    or require("spectrolite.modes._hsla").parse(str)
    or require("spectrolite.modes.hsl").parse(str)
    or require("spectrolite.modes._hxla").parse(str)
    or require("spectrolite.modes.hxl").parse(str)
    or nil
end

M.convert = function(mode, coords)
  if not coords then
    return nil
  end

  local r, g, b, a = coords.r, coords.g, coords.b, coords.a
  return require("spectrolite.modes." .. M.modes[mode].group).convert(
    r,
    g,
    b,
    a
  )
end

M.format = function(coords)
  if not coords then
    return nil
  end

  if type(coords) == "string" then
    return require("spectrolite.modes.hexa").format(coords)
  end

  if coords.r and coords.g and coords.b then
    return require("spectrolite.modes._rgba").format(
      coords.r,
      coords.g,
      coords.b,
      coords.a
    )
  end

  if coords.s and coords.h and coords.l then
    return require("spectrolite.modes._hsla").format(
      coords.h,
      coords.s,
      coords.l,
      coords.a
    )
  end

  if coords.x and coords.h and coords.l then
    return require("spectrolite.modes._hxla").format(
      coords.h,
      coords.x,
      coords.l,
      coords.a
    )
  end
end

return M
