local M = {}

function M.spectrolite(model)
  if not model then
    return
  end

  local spectrolite = require("spectrolite")

  local str_in, sel = spectrolite.read()
  if not str_in or not sel then
    return
  end

  local str_out = spectrolite.convert(str_in, model)
  if not str_out then
    return
  end

  spectrolite.write(sel, str_out)
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
