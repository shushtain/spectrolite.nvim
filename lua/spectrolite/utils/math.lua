local M = {}

---@param num number
---@param precision? number
---@return number
function M.round(num, precision)
  if num % 1 == 0 then
    return num
  end

  local margin = math.pow(10, precision or 0)
  return math.floor(num * margin + 0.5) / margin
end

return M
