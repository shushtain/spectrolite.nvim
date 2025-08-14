-- TEST:

local parse = require("spectrolite.parse")
local convert = require("spectrolite.convert")
local format = require("spectrolite.format")

local data = {
  {
    input = "#F00",
    output = {
      hex = "#FF0000",
      rgb = "rgb(255, 0, 0)",
      hsl = "hsl(0, 100%, 50%)",
    },
  },
  {
    input = "#F009",
    output = {
      hex = "#FF000099",
      rgb = "rgba(255, 0, 0 / 0.60)",
      hsl = "hsla(0, 100%, 50% / 0.60)",
    },
  },
  {
    input = "#FF0000",
    output = {
      hex = "#FF0000",
      rgb = "rgb(255, 0, 0)",
      hsl = "hsl(0, 100%, 50%)",
    },
  },
  {
    input = "#FF000099",
    output = {
      hex = "#FF000099",
      rgb = "rgba(255, 0, 0 / 0.60)",
      hsl = "hsla(0, 100%, 50% / 0.60)",
    },
  },
  {
    input = "rgb(255, 0, 0)",
    output = {
      hex = "#FF0000",
      rgb = "rgb(255, 0, 0)",
      hsl = "hsl(0, 100%, 50%)",
    },
  },
  {
    input = "rgba(255, 0, 0, 0.6)",
    output = {
      hex = "#FF000099",
      rgb = "rgba(255, 0, 0 / 0.60)",
      hsl = "hsla(0, 100%, 50% / 0.60)",
    },
  },
  {
    input = "hsl(0, 100, 50%)",
    output = {
      hex = "#FF0000",
      rgb = "rgb(255, 0, 0)",
      hsl = "hsl(0, 100%, 50%)",
    },
  },
  {
    input = "hsla(0, 100%, 50, 0.6)",
    output = {
      hex = "#FF000099",
      rgb = "rgba(255, 0, 0 / 0.60)",
      hsl = "hsla(0, 100%, 50% / 0.60)",
    },
  },
}

for _, item in ipairs(data) do
  local clr = parse.auto(item.input)
  -- print("Processing " .. item.input)

  local hex = convert.to_hex(clr)
  -- print(vim.inspect(hex))
  local hexed = format.hex(hex)
  -- print(vim.inspect(hexed))
  local rgb = clr
  -- print(vim.inspect(rgb))
  local rgbed = format.rgb(rgb)
  -- print(vim.inspect(rgbed))
  local hsl = convert.to_hsl(clr)
  -- print(vim.inspect(hsl))
  local hsled = format.hsl(hsl)
  -- print(vim.inspect(hsled))

  if hexed ~= item.output.hex then
    print(
      "for "
        .. item.input
        .. " expected "
        .. item.output.hex
        .. " got "
        .. hexed
    )
  end
  if rgbed ~= item.output.rgb then
    print(
      "for "
        .. item.input
        .. " expected "
        .. item.output.rgb
        .. " got "
        .. rgbed
    )
  end
  if hsled ~= item.output.hsl then
    print(
      "for "
        .. item.input
        .. " expected "
        .. item.output.hsl
        .. " got "
        .. hsled
    )
  end
end

print("ALL DONE")
