local M = {}

M.round = function(num, precision)
  if not num then
    return nil
  end

  if num % 1 == 0 then
    return num
  end
  local margin = math.pow(10, precision or 0)
  return math.floor(num * margin + 0.5) / margin
end

M.checked_input = function(input)
  if not input then
    return nil
  end

  if input:gsub("%s", "") == "" then
    return nil
  end

  return input
end

M.checked_mode = function(mode)
  if not mode then
    return nil
  end

  if not vim.tbl_contains(vim.tbl_keys(M.modes), mode) then
    return nil
  end

  return mode
end

M.hue_to_rgb = function(temp1, temp2, tempC)
  if 6 * tempC < 1 then
    return temp2 + (temp1 - temp2) * tempC * 6
  elseif 2 * tempC < 1 then
    return temp1
  elseif 3 * tempC < 2 then
    return temp2 + (temp1 - temp2) * (2 / 3 - tempC) * 6
  else
    return temp2
  end
end

M.get_selection = function()
  -- exit selection to finalize it
  -- vim.api.nvim_feedkeys("\27", "n", false)

  -- 1-based
  local spos = vim.fn.getpos("'<")
  local epos = vim.fn.getpos("'>")

  if not spos or not epos then
    vim.notify("No selection detected", vim.log.levels.WARN)
    return nil
  end

  local srow = spos[2]
  local scol = spos[3]
  local erow = epos[2]
  local ecol = epos[3]

  if srow ~= erow then
    vim.notify("Color must be on a single line", vim.log.levels.WARN)
    return nil
  end

  -- Fix for V-mode overflow
  local line = vim.fn.getline(srow)
  ecol = math.min(ecol, #line)

  -- if ecol < scol then
  --   scol, ecol = ecol, scol
  -- end

  return { srow = srow, scol = scol, erow = erow, ecol = ecol }
end

M.read = function(selection)
  local text = vim.api.nvim_buf_get_text(
    0,
    selection.srow - 1,
    selection.scol - 1,
    selection.erow - 1,
    selection.ecol,
    {}
  )[1]

  if not text or text:gsub("%s", "") == "" then
    vim.notify("Selection is empty", vim.log.levels.WARN)
    return nil
  end

  return text
end

M.write = function(selection, text)
  vim.api.nvim_buf_set_text(
    0,
    selection.srow - 1,
    selection.scol - 1,
    selection.erow - 1,
    selection.ecol,
    { text }
  )
end

M.complete = function(prefix, line, col)
  line = line:sub(1, col):match("Spectrolite%s*(.*)$")
  local candidates = vim.tbl_keys(M.modes)

  for _, candidate in ipairs(candidates) do
    if line:match(candidate) then
      return {}
    end
  end

  candidates = vim.tbl_filter(function(x)
    return tostring(x):find(prefix, 1, true) == 1
  end, candidates)

  table.sort(candidates)
  return candidates
end

return M
