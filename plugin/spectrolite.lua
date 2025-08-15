if vim.g.spectrolite_loaded then
  return
end
vim.g.spectrolite_loaded = true

vim.api.nvim_create_user_command("Spectrolite", function(cmd)
  local mode

  if cmd.nargs == 0 then
    local modes = require("spectrolite.utils.math").modes
    vim.ui.select(vim.tbl_keys(modes), {
      prompt = "Target color space: ",
      format_item = function(opt)
        return modes[opt].name
      end,
    }, function(opt)
      mode = opt
    end)
  else
    mode = cmd.fargs[1]:gsub("%s", "")
  end

  if mode then
    require("spectrolite").convert(mode)
  end
end, {
  nargs = "?",
  range = true,
  desc = "Convert color into target mode",
  complete = function(prefix, line, col)
    line = line:sub(1, col):match("Spectrolite%s*([^%s]*)$")
    if not line then
      return {}
    end

    local candidates = require("spectrolite.models.srgb.init").modes
    candidates = vim.tbl_keys(candidates)
    candidates = vim.tbl_filter(function(x)
      return tostring(x):find(prefix, 1, true) == 1
    end, candidates)

    table.sort(candidates)
    return candidates
  end,
})
