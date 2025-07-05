local M = {}

M.round = function(num, points)
  -- int -> return
  if num % 1 == 0 then
    return num
  end

  points = points or 0
  local margin = math.pow(10, points)

  return math.floor(num * margin + 0.5) / margin
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

M.read = function()
  local selection = {}

  -- exit visual mode to update marks
  vim.cmd(
    "normal! " .. vim.api.nvim_replace_termcodes("<Esc>", true, false, true)
  )

  -- Get start and end positions of the current selection
  -- these are 1-based
  local start_pos = vim.fn.getpos("'<")
  local end_pos = vim.fn.getpos("'>")

  if not start_pos or not end_pos then
    vim.notify("Could not get selection", vim.log.levels.WARN)
    return nil
  end

  -- Add them as reference points
  local start_line = start_pos[2]
  local start_col = start_pos[3]
  local end_line = end_pos[2]
  local end_col = end_pos[3]

  if start_line ~= end_line then
    vim.notify("Color must be on a single line", vim.log.levels.WARN)
    return nil
  end

  if end_col < start_col then
    start_col, end_col = end_col, start_col
  end

  -- Get the text within these bounds
  -- these are 0-based, with exclusive end_col
  local text = vim.api.nvim_buf_get_text(
    0,
    start_line - 1,
    start_col - 1,
    end_line - 1,
    end_col,
    {}
  )[1]

  if not text or text == "" then
    vim.notify("Selection is empty", vim.log.levels.WARN)
    return nil
  end

  return {
    start_line = start_line,
    start_col = start_col,
    end_line = end_line,
    end_col = end_col,
    text = text,
  }
end

M.write = function(selection)
  vim.api.nvim_buf_set_text(
    0,
    selection.start_line - 1,
    selection.start_col - 1,
    selection.end_line - 1,
    selection.end_col,
    { selection.text }
  )
end

return M
