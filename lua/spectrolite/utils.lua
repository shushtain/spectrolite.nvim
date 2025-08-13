local M = {}

function M.round(num, precision)
  if not num then
    return nil
  end

  if num % 1 == 0 then
    return num
  end
  local margin = math.pow(10, precision or 0)
  return math.floor(num * margin + 0.5) / margin
end

function M.check_mode(mode)
  return mode and vim.tbl_contains(vim.tbl_keys(M.modes), mode)
end

function M.get_selection()
  -- exit selection to finalize it
  -- vim.api.nvim_feedkeys("\27", "n", false)

  -- 1-based
  local ok_spos, spos = pcall(vim.fn.getpos, "'<")
  if not ok_spos then
    return nil
  end

  local ok_epos, epos = pcall(vim.fn.getpos, "'>")
  if not ok_epos then
    return nil
  end

  if not spos or not epos then
    return nil
  end

  local srow = spos[2]
  local scol = spos[3]
  local erow = epos[2]
  local ecol = epos[3]

  if not srow or not scol or not erow or not ecol then
    return nil
  end

  if srow ~= erow then
    vim.notify("Color must be on a single line", vim.log.levels.WARN)
    return nil
  end

  -- Fix for V-mode overflow
  local ok_line, line = pcall(vim.fn.getline, srow)
  if not ok_line then
    return nil
  end
  ecol = math.min(ecol, #line)

  -- if ecol < scol then
  --   scol, ecol = ecol, scol
  -- end

  return { srow = srow, scol = scol, erow = erow, ecol = ecol }
end

function M.read(selection)
  if not selection then
    return nil
  end

  local ok, text = pcall(
    vim.api.nvim_buf_get_text,
    0,
    selection.srow - 1,
    selection.scol - 1,
    selection.erow - 1,
    selection.ecol,
    {}
  )

  if not ok or not text then
    return nil
  end

  local line = text[1]

  if not line or line:gsub("%s", "") == "" then
    return nil
  end

  return line
end

function M.write(selection, text)
  if not selection or not text then
    vim.notify("Could not write to buffer", vim.log.levels.WARN)
    return nil
  end

  local ok = pcall(
    vim.api.nvim_buf_set_text,
    0,
    selection.srow - 1,
    selection.scol - 1,
    selection.erow - 1,
    selection.ecol,
    { text }
  )

  if not ok then
    vim.notify("Could not write to buffer", vim.log.levels.WARN)
  end
end

return M
