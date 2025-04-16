-- All conversions happen through RGB(A).
-- Except for HEX, returned values are tables with non-rounded values.
-- HSL is returned as bare degree and percentage values.
-- Alpha is returned as `float` or `nil`.

local utils = require("spectrolite.utils")
local M = {}

M.to_hex = function(color)
	local r, g, b, a = color.r, color.g, color.b, color.a
	if a then
		return "#" .. string.format("%02x%02x%02x%02x", r, g, b, 255 * a)
	end
	return "#" .. string.format("%02x%02x%02x", r, g, b)
end

M.from_hex = function(hex)
	hex = hex:gsub("#", "")

	if hex:len() == 3 then
		return {
			r = tonumber("0x" .. hex:sub(1, 1) .. hex:sub(1, 1)),
			g = tonumber("0x" .. hex:sub(2, 2) .. hex:sub(2, 2)),
			b = tonumber("0x" .. hex:sub(3, 3) .. hex:sub(3, 3)),
		}
	elseif hex:len() == 4 then
		return {
			r = tonumber("0x" .. hex:sub(1, 1) .. hex:sub(1, 1)),
			g = tonumber("0x" .. hex:sub(2, 2) .. hex:sub(2, 2)),
			b = tonumber("0x" .. hex:sub(3, 3) .. hex:sub(3, 3)),
			a = tonumber("0x" .. hex:sub(4, 4) .. hex:sub(4, 4)) / 255,
		}
	elseif hex:len() == 6 then
		return {
			r = tonumber("0x" .. hex:sub(1, 2)),
			g = tonumber("0x" .. hex:sub(3, 4)),
			b = tonumber("0x" .. hex:sub(5, 6)),
		}
	elseif hex:len() == 8 then
		return {
			r = tonumber("0x" .. hex:sub(1, 2)),
			g = tonumber("0x" .. hex:sub(3, 4)),
			b = tonumber("0x" .. hex:sub(5, 6)),
			a = tonumber("0x" .. hex:sub(7, 8)) / 255,
		}
	end
end

M.to_hsl = function(color)
	local r, g, b, a = color.r, color.g, color.b, color.a
	r = r / 255
	g = g / 255
	b = b / 255

	local max = math.max(r, g, b)
	local min = math.min(r, g, b)

	local h = 0
	local s = 0
	local l = (max + min) / 2

	if min ~= max then
		if l <= 0.5 then
			s = (max - min) / (max + min)
		else
			s = (max - min) / (2 - max - min)
		end

		if max == r then
			h = (g - b) / (max - min)
		elseif max == g then
			h = 2 + (b - r) / (max - min)
		else
			h = 4 + (r - g) / (max - min)
		end

		h = h * 60
		h = h % 360
	end

	return { h = h, s = s * 100, l = l * 100, a = a }
end

M.from_hsl = function(color)
	local h, s, l, a = color.h, color.s, color.l, color.a
	s = s / 100
	l = l / 100

	if s == 0 then
		return { r = l * 255, g = l * 255, b = l * 255, a = a }
	end

	local temp1, temp2, tempR, tempG, tempB

	if l < 0.5 then
		temp1 = l * (1 + s)
	else
		temp1 = l + s - l * s
	end

	temp2 = 2 * l - temp1

	h = h % 360
	h = h / 360

	tempR = (h + 1 / 3) % 1
	tempG = h
	tempB = (h - 1 / 3) % 1

	local r = utils.hue_to_rgb(temp1, temp2, tempR)
	local g = utils.hue_to_rgb(temp1, temp2, tempG)
	local b = utils.hue_to_rgb(temp1, temp2, tempB)

	return { r = r * 255, g = g * 255, b = b * 255, a = a }
end

local A = -0.14861
local B = 1.78277
local C = -0.29227
local D = -0.90649
local E = 1.97294
local ED = E * D
local EB = E * B
local BC_DA = B * C - D * A

M.to_hxl = function(color)
	local r, g, b, a = color.r, color.g, color.b, color.a

	r = r / 255
	g = g / 255
	b = b / 255

	local l = (BC_DA * b + ED * r - EB * g) / (BC_DA + ED - EB)
	local bl = b - l
	local k = (E * (g - l) - C * bl) / D

	local x = 0
	if l > 0 and l < 1 then
		x = math.sqrt(k * k + bl * bl) / (E * l * (1 - l))
	end

	local h = 0
	if x > 0 then
		h = math.atan2(k, bl) * (180 / math.pi) - 120
	end

	h = h % 360
	x = x * 100
	l = l * 100

	return { h = h, x = x, l = l, a = a }
end

M.from_hxl = function(color)
	local h, x, l, a = color.h, color.x, color.l, color.a
	x = x / 100
	l = l / 100

	if l <= 0 then
		return { r = 0, g = 0, b = 0, a = a }
	end
	if l >= 1 then
		return { r = 255, g = 255, b = 255, a = a }
	end

	h = (math.pi * (h + 120)) / 180

	if x <= 0 then
		h = 0
	end

	local k = x * l * (1 - l)
	local cosh = math.cos(h)
	local sinh = math.sin(h)

	local r = l + k * (A * cosh + B * sinh)
	local g = l + k * (C * cosh + D * sinh)
	local b = l + k * (E * cosh)

	r = math.min(1, math.max(0, r))
	g = math.min(1, math.max(0, g))
	b = math.min(1, math.max(0, b))

	return { r = r * 255, g = g * 255, b = b * 255, a = a }
end

return M
