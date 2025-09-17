local go = require("spectrolite")

local M = {}

describe("Normalize:", function()
  it("valid_hex", function()
    local res

    res = go.normalize("hex", go.parse("#fff"))
    assert.are.same(res, { rn = 1, gn = 1, bn = 1, an = 1 })
    res = go.normalize("hexa", go.parse("#ffff"))
    assert.are.same(res, { rn = 1, gn = 1, bn = 1, an = 1 })
  end)
  it("valid_hsl", function()
    local res

    res = go.normalize("hsl", go.parse("hsl(255, 23, 100)"))
    assert.are.same(res, { rn = 1, gn = 1, bn = 1, an = 1 })
    res = go.normalize("hsla", go.parse("hsla(255, 23, 100 100%)"))
    assert.are.same(res, { rn = 1, gn = 1, bn = 1, an = 1 })
    res = go.normalize("hsla", go.parse("hsla(255, 23, 100 /1)"))
    assert.are.same(res, { rn = 1, gn = 1, bn = 1, an = 1 })
  end)
  it("valid_hxl", function()
    local res
    res = go.normalize("hxl", go.parse("hxl(255, 23, 0)"))
    assert.are.same(res, { rn = 0, gn = 0, bn = 0, an = 1 })
    res = go.normalize("hxla", go.parse("hxla(255, 23, 100 0%)"))
    assert.are.same(res, { rn = 1, gn = 1, bn = 1, an = 0 })
    res = go.normalize("hxla", go.parse("hxla(255, 23, 0 /.1)"))
    assert.are.same(res, { rn = 0, gn = 0, bn = 0, an = 0.1 })
  end)
  it("valid_rgb", function()
    local res
    res = go.normalize("rgb", go.parse("rgb(0 255 0)"))
    assert.are.same(res, { rn = 0, gn = 1, bn = 0, an = 1 })
    res = go.normalize("rgba", go.parse("rgba(255 255 0 25%)"))
    assert.are.same(res, { rn = 1, gn = 1, bn = 0, an = 0.25 })
  end)
end)
