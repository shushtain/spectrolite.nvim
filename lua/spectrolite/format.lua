-- All conversions happen through RGB(A).
-- Except for HEX, returned values are tables with non-rounded values.
-- HSL is returned as bare degree and percentage values.
-- Alpha is returned as `float` or `nil`.

local config = require("spectrolite.config")
local utils = require("spectrolite.utils")
local M = {}

M.hex = function(hex)
	if not hex then
		vim.notify("Cannot format as HEX", vim.log.levels.WARN)
	end

	local lower_hex = config.options.lower_hex
	return lower_hex and hex:lower() or hex:upper()
end

M.rgb = function(color)
	local r, g, b, a = color.r, color.g, color.b, color.a
	if not r or not g or not b then
		vim.notify("Cannot format as RGB", vim.log.levels.WARN)
	end

	r = utils.round(r)
	g = utils.round(g)
	b = utils.round(b)

	if a then
		a = utils.round(a, 2)
		return string.format("rgba(%d, %d, %d / %.2f)", r, g, b, a)
	end

	return string.format("rgb(%d, %d, %d)", r, g, b)
end

M.hsl = function(color)
	local h, s, l, a = color.h, color.s, color.l, color.a
	if not h or not s or not l then
		vim.notify("Cannot format as HSL", vim.log.levels.WARN)
	end

	local round = config.options.round_hsl
	local points = round and 0 or 2
	h = utils.round(h, points)
	s = utils.round(s, points)
	l = utils.round(l, points)

	if a then
		a = utils.round(a, 2)
		if round then
			return string.format("hsla(%d, %d%%, %d%% / %.2f)", h, s, l, a)
		end
		return string.format("hsla(%.2f, %.2f%%, %.2f%% / %.2f)", h, s, l, a)
	end

	if round then
		return string.format("hsl(%d, %d%%, %d%%)", h, s, l)
	end
	return string.format("hsl(%.2f, %.2f%%, %.2f%%)", h, s, l)
end

M.hxl = function(color)
	local h, x, l, a = color.h, color.x, color.l, color.a
	if not h or not x or not l then
		vim.notify("Cannot format as Cubehelix", vim.log.levels.WARN)
	end

	local round = config.options.round_hxl
	local points = round and 0 or 2
	h = utils.round(h, points)
	x = utils.round(x, points)
	if x == 0 then
		h = 0
	end
	l = utils.round(l, points)

	if a then
		a = utils.round(a, 2)
		if round then
			return string.format("hxla(%d, %d%%, %d%% / %.2f)", h, x, l, a)
		end
		return string.format("hxla(%.2f, %.2f%%, %.2f%% / %.2f)", h, x, l, a)
	end

	if round then
		return string.format("hxl(%d, %d%%, %d%%)", h, x, l)
	end
	return string.format("hxl(%.2f, %.2f%%, %.2f%%)", h, x, l)
end

return M
