---@class Spectrolite.Mode
---@field parse fun(str: string): { r: number, g: number, b: number, a: number } | nil Parse to RGBA coordinates
---@field to_rgba fun(...): { r: number, g: number, b: number, a: number } Convert to shared RGBA mode
---@field convert fun(r: number, g: number, b: number, a?: number): table|string Convert to local mode
---@field format fun(...): string Format coordinates into string
---@field round fun(...): table|string Round values

local M = {}

M.modes = {
  hex = { repr = "HEX", group = "hexa" },
  hexa = { repr = "HEXA", group = "hexa" },
  hsl = { repr = "HSL", group = "hsla" },
  hsla = { repr = "HSLA", group = "hsla" },
  hxl = { repr = "HXL (Cubehelix)", group = "hxla" },
  hxla = { repr = "HXLA (Cubehelix with Alpha)", group = "hxla" },
  rgb = { repr = "RGB", group = "rgba" },
  rgba = { repr = "RGBA", group = "rgba" },
}

M.parse = function(str)
  if not str then
    return nil
  end

  str = str:lower()
  return require("spectrolite.modes.hexa").parse(str)
    or require("spectrolite.modes.rgba").parse(str)
    or require("spectrolite.modes.hsla").parse(str)
    or require("spectrolite.modes.hxla").parse(str)
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
    return require("spectrolite.modes.rgba").format(
      coords.r,
      coords.g,
      coords.b,
      coords.a
    )
  end

  if coords.s and coords.h and coords.l then
    return require("spectrolite.modes.hsla").format(
      coords.h,
      coords.s,
      coords.l,
      coords.a
    )
  end

  if coords.x and coords.h and coords.l then
    return require("spectrolite.modes.hxla").format(
      coords.h,
      coords.x,
      coords.l,
      coords.a
    )
  end
end

return M
