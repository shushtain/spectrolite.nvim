local go = require("spectrolite")

local M = {}

describe("Denormalize:", function()
  it("valid_hex", function()
    local model, normal, color

    model = "hex"
    color = go.parse("#fff")
    normal = go.normalize(model, color)
    assert.are.same(go.denormalize(model, normal), color)

    model = "hexa"
    color = go.parse("#ffff")
    normal = go.normalize(model, color)
    assert.are.same(go.denormalize(model, normal), color)
  end)
  it("valid_hsl", function()
    local model, normal, color
    model = "hsl"
    color = go.parse("hsl(255, 23, 100)")
    normal = go.normalize(model, color)
    assert.are.same(go.denormalize(model, normal)["l"], color.l)

    model = "hsla"
    color = go.parse("hsla(255, 23, 100 100%)")
    normal = go.normalize(model, color)
    assert.are.same(go.denormalize(model, normal)["l"], color.l)
  end)
  it("valid_hxl", function()
    local model, normal, color
    model = "hxl"
    color = go.parse("hxl(255, 23, 0)")
    normal = go.normalize(model, color)
    assert.are.same(go.denormalize(model, normal)["l"], color.l)

    model = "hxla"
    color = go.parse("hxla(255, 23, 0 /.1)")
    normal = go.normalize(model, color)
    assert.are.same(go.denormalize(model, normal)["l"], color.l)
  end)
  it("valid_rgb", function()
    local model, normal, color
    model = "rgb"
    color = go.parse("rgb(0, 255, 0)")
    normal = go.normalize(model, color)
    assert.are.same(go.denormalize(model, normal), color)

    model = "rgba"
    color = go.parse("rgba(0, 255, 0 /.33)")
    normal = go.normalize(model, color)
    assert.are.same(go.denormalize(model, normal), color)
  end)
end)
