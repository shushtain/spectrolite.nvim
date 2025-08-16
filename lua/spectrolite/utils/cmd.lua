local M = {}

function M.spectrolite(str_in, model_out, sel)
  local convert = require("spectrolite").convert
  local write = require("spectrolite").write

  local str_out = convert(str_in, model_out)
  if not str_out then
    return
  end

  write(sel, str_out)
end

function M.complete(prefix, line, col)
  line = line:sub(1, col):match("Spectrolite%s+([^%s]*)$")
  if not line then
    return {}
  end

  local models = require("spectrolite.models").models
  models = vim.tbl_keys(models)
  models = vim.tbl_filter(function(x)
    return tostring(x):find(prefix, 1, true) == 1
  end, models)

  table.sort(models)
  return models
end

return M
