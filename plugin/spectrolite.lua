if vim.g.spectrolite then
  return
end
vim.g.spectrolite = {}

vim.api.nvim_create_user_command("Spectrolite", function(cmd)
  local handle = require("spectrolite.utils.cmd").spectrolite
  local read = require("spectrolite").read

  local models = require("spectrolite.models").models
  local model_keys = vim.tbl_keys(models)

  local str, sel = read()
  if not str or not sel then
    return
  end

  if not cmd or not cmd.fargs or #cmd.fargs == 0 then
    table.sort(model_keys)
    vim.ui.select(model_keys, {
      prompt = "Target color model: ",
      format_item = function(opt)
        return models[opt].name
      end,
    }, function(choice)
      if choice then
        handle(str, choice, sel)
      end
    end)
  else
    local model = cmd.fargs[1]:gsub("%s", "")
    if not vim.tbl_contains(model_keys, model) then
      vim.notify("Model " .. model .. " is not supported", vim.log.levels.WARN)
      return
    end
    handle(str, model, sel)
  end
end, {
  nargs = "?",
  range = true,
  desc = "Convert color into target mode",
  complete = function(...)
    return require("spectrolite.utils.cmd").complete_spectrolite(...)
  end,
})

vim.api.nvim_create_user_command("SpectroliteHighlighter", function(cmd)
  require("spectrolite.highlighter")[cmd.fargs[1]]()
end, {
  nargs = 1,
  desc = "Highlight colors in the buffer",
  complete = function(...)
    return require("spectrolite.utils.cmd").complete_highlighter(...)
  end,
})
