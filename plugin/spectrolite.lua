if vim.g.spectrolite_loaded then
  return
end
vim.g.spectrolite_loaded = true

vim.api.nvim_create_user_command("Spectrolite", function(cmd)
  local model

  if cmd.nargs == 0 then
    local models = require("spectrolite.models").models
    vim.ui.select(vim.tbl_keys(models), {
      prompt = "Target color space: ",
      format_item = function(opt)
        return models[opt].name
      end,
    }, function(opt)
      model = opt
    end)
  else
    model = cmd.fargs[1]:gsub("%s", "")
  end

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
end, {
  nargs = "?",
  range = true,
  desc = "Convert color into target mode",
  complete = function(prefix, line, col)
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
  end,
})
