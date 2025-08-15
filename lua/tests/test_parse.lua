local go = require("spectrolite")

local M = {}

describe("Parse:", function()
  it("valid", function()
    local model

    _, model = go.parse("#2ec")
    assert.are.same(model, "hex")
    _, model = go.parse("#22eEcc")
    assert.are.same(model, "hex")

    _, model = go.parse("#2eCa")
    assert.are.same(model, "hexa")
    _, model = go.parse("#22EECCAA")
    assert.are.same(model, "hexa")

    _, model = go.parse("hsl(360, 50, 25)")
    assert.are.same(model, "hsl")
    _, model = go.parse("hsl(0 100% 20)")
    assert.are.same(model, "hsl")

    _, model = go.parse("hsla(360, 50% 25 /25%)")
    assert.are.same(model, "hsla")
    _, model = go.parse("hsla(0 100% 20, .33)")
    assert.are.same(model, "hsla")

    _, model = go.parse("hxl(360, 50, 25)")
    assert.are.same(model, "hxl")
    _, model = go.parse("hxl(0 100% 20)")
    assert.are.same(model, "hxl")

    _, model = go.parse("hxla(360, 50% 25 /25%)")
    assert.are.same(model, "hxla")
    _, model = go.parse("hxla(0 100% 20, .33)")
    assert.are.same(model, "hxla")

    _, model = go.parse("rgb(360, 50, 25)")
    assert.are.same(model, "rgb")
    _, model = go.parse("rgb(0 100 20)")
    assert.are.same(model, "rgb")

    _, model = go.parse("rgba(360, 50 25 /25%)")
    assert.are.same(model, "rgba")
    _, model = go.parse("rgba(0 100 20, .33)")
    assert.are.same(model, "rgba")
  end)

  it("invalid", function()
    assert.is_nil(go.parse("sdhffjalfj"))
    assert.is_nil(go.parse("0000"))
    assert.is_nil(go.parse("#02"))
    assert.is_nil(go.parse("#000fff2"))
    assert.is_nil(go.parse("#zzz"))
    assert.is_nil(go.parse("hxla(-20 0 30)"))
    assert.is_nil(go.parse("hxla(200 2 0 30 0)"))
    assert.is_nil(go.parse("rgb(2% 23% 0)"))
    assert.is_nil(go.parse("hsl(% 3 0)"))
    assert.is_nil(go.parse("hsl(3 0)"))
  end)
end)
