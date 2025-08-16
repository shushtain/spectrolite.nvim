---@class Spectrolite._Selection
---@field srow number
---@field scol number
---@field erow number
---@field ecol number

---@class Spectrolite.Selection
---@field srow number
---@field scol number
---@field erow number
---@field ecol number

local M = {}

---@return Spectrolite._Selection?
function M.get_selection()
  -- exit selection to finalize it
  vim.cmd("normal! \27")
  -- vim.cmd("normal! gv")

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

  return { srow = srow, scol = scol, erow = erow, ecol = ecol }
end

---@param sel Spectrolite._Selection
---@return Spectrolite.Selection?
function M.validate_selection(sel)
  local srow, scol, erow, ecol = sel.srow, sel.scol, sel.erow, sel.ecol

  if not srow or not scol or not erow or not ecol then
    return nil
  end

  if srow ~= erow then
    return nil
  end

  -- Fix for V-mode overflow
  local ok_line, line = pcall(vim.fn.getline, srow)
  if not ok_line then
    return nil
  end
  ecol = math.min(ecol, #line)

  return { srow = srow, scol = scol, erow = erow, ecol = ecol }
end

---@param sel Spectrolite.Selection
---@return string?
function M.read(sel)
  if not sel then
    return nil
  end

  local ok, lines = pcall(
    vim.api.nvim_buf_get_text,
    0,
    sel.srow - 1,
    sel.scol - 1,
    sel.erow - 1,
    sel.ecol,
    {}
  )

  if not ok or not lines then
    return nil
  end

  local str = lines[1]

  if not str or str:gsub("%s", "") == "" then
    return nil
  end

  return str
end

---@param sel Spectrolite.Selection
---@param str string
---@return boolean?
function M.write(sel, str)
  if not sel or not str then
    return nil
  end

  local ok = pcall(
    vim.api.nvim_buf_set_text,
    0,
    sel.srow - 1,
    sel.scol - 1,
    sel.erow - 1,
    sel.ecol,
    { str }
  )

  if ok then
    vim.fn.setpos("'<", { 0, sel.srow, sel.scol, 0 })
    vim.fn.setpos("'>", { 0, sel.erow, sel.scol + #str - 1, 0 })
    vim.cmd("normal! gv")
    vim.cmd("normal! \27")
  end

  return ok
end

return M
