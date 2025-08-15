if vim.g.spectrolite_loaded then
  return
end
vim.g.spectrolite_loaded = true

vim.api.nvim_create_user_command("Spectrolite", function(cmd)
  local handle = require("spectrolite.utils.cmd").spectrolite
  if not cmd or not cmd.fargs or #cmd.fargs == 0 then
    local models = require("spectrolite.models").models
    vim.ui.select(vim.tbl_keys(models), {
      prompt = "Target color space: ",
      format_item = function(opt)
        return models[opt].name
      end,
    }, function(choice)
      handle(choice)
    end)
    return
  end
  handle(cmd.fargs[1]:gsub("%s", ""))
end, {
  nargs = "?",
  range = true,
  desc = "Convert color into target mode",
  complete = function(...)
    return require("spectrolite.utils.cmd").complete(...)
  end,
})
