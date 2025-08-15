local go = require("spectrolite")

describe("Convert:", function()
  it("valid", function()
    local model_out, str_in, str_out

    model_out = "rgba"
    str_in = "#fff"
    str_out = "rgba(255 255 255 / 1)"

    assert.are.same(go.convert(str_in, model_out), str_out)

    model_out = "hxla"
    str_in = "#fff"
    str_out = "hxla(0 0 100 / 1)"

    assert.are.same(go.convert(str_in, model_out), str_out)
  end)

  it("big_one", function()
    local color = go.convert("#fff", "hxla")
    color = go.convert(color, "rgba")
    color = go.convert(color, "hsl")
    color = go.convert(color, "hsla")
    color = go.convert(color, "hex")
    color = go.convert(color, "rgba")
    color = go.convert(color, "rgb")
    color = go.convert(color, "hxl")
    color = go.convert(color, "hsl")
    color = go.convert(color, "hsl")
    color = go.convert(color, "hexa")

    assert.is_true(type(color) == "string")
  end)
end)
