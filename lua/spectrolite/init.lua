---@class Spectrolite

local M = {}

---Read from selection. Multi-line input is not supported.
---Does not check if valid color is read. Use `parse()` to validate output.
---@return string? str Captured string. `nil` if selection is multi-line
---@return Spectrolite.Selection? selection Captured selection
function M.read()
  local utils = require("spectrolite.utils.buffer")

  local sel = utils.get_selection()
  if not sel then
    vim.notify("Cannot capture selection", vim.log.levels.WARN)
    return nil
  end

  local selection = utils.validate_selection(sel)
  if not selection then
    vim.notify(
      "Cannot validate selection. Make sure it's single-line",
      vim.log.levels.WARN
    )
    return nil
  end

  local str = utils.read(selection)
  if not str then
    vim.notify("Cannot read from selection", vim.log.levels.WARN)
    return nil
  end

  return str, selection
end

---Parse `str` into color coordinates with no conversion.
---If `model` is present, `str` must represent that model.
---If `model` is omitted/`nil`, try against each available.
---@param str string Color in CSS-like format
---@param model? Spectrolite.Models Color model to parse into
---@return Spectrolite.Colors? color Color coordinates
---@return Spectrolite.Models? model_out Echoed from input or auto-defined
function M.parse(str, model)
  local input = str:lower()
  local color, model_out

  if model then
    local base = M.get_base(model)
    color = require("spectrolite.models." .. base .. "." .. model).parse(input)
    model_out = model
  else
    local models = require("spectrolite.models").models
    for k, v in pairs(models) do
      color = require("spectrolite.models." .. v.base .. "." .. k).parse(input)
      model_out = k
      if color then
        break
      end
    end
  end

  if not color then
    if model then
      vim.notify(
        "Cannot parse from "
          .. vim.inspect(str)
          .. " into model "
          .. vim.inspect(model),
        vim.log.levels.WARN
      )
    else
      vim.notify("Cannot parse from " .. vim.inspect(str), vim.log.levels.WARN)
    end
    return nil
  end

  return color, model_out
end

---Turn color coordinates into normalized coordinates for that model group.
---@param model Spectrolite.Models Color model to normalize from
---@param color Spectrolite.Colors Color coordinates
---@return Spectrolite.Normals normal Normalized coordinates
function M.normalize(model, color)
  local base = M.get_base(model)
  return require("spectrolite.models." .. base .. "." .. model).normalize(color)
end

---Get base (model group) of model
---@param model Spectrolite.Models
---@return Spectrolite.Bases base
function M.get_base(model)
  local models = require("spectrolite.models").models
  return models[model].base
end

---@deprecated
---Switch model groups by converting normalized coordinates
---@param base_in Spectrolite.Bases Base to switch from
---@param base_out Spectrolite.Bases Base to switch to
---@param normal Spectrolite.Normals Normalized coordinates
---@return Spectrolite.Normals normal_out Normalized coordinates
function M.rebase(base_in, base_out, normal)
  local abs = require("spectrolite.models." .. base_in).globalize(normal)
  return require("spectrolite.models." .. base_out).localize(abs)
end

---Denormalize coordinates into color values of `model`.
---@param model Spectrolite.Models Model to convert into
---@param normal Spectrolite.Normals Normalized coordinates. Typically received from `normalize()`
---@return Spectrolite.Colors color Color coordinates
function M.denormalize(model, normal)
  local base = M.get_base(model)
  return require("spectrolite.models." .. base .. "." .. model).denormalize(
    normal
  )
end

---Format color coordinates
---@param model Spectrolite.Models Model of color coordinates
---@param color Spectrolite.Colors Color coordinates
---@param opts? Spectrolite.Config Temporary config overrides
---@return Spectrolite.Colors color_out Color coordinates
function M.format(model, color, opts)
  local options = require("spectrolite.config").config
  options = vim.tbl_deep_extend("force", options, opts or {})

  local base = M.get_base(model)
  return require("spectrolite.models." .. base .. "." .. model).format(
    color,
    options
  )
end

---Turn color coordinates into CSS-like string
---@param model Spectrolite.Models Model of color coordinates
---@param color Spectrolite.Colors Color coordinates
---@param opts? Spectrolite.Config Temporary config overrides
---@return string str Color in CSS-like format
function M.print(model, color, opts)
  local options = require("spectrolite.config").config
  options = vim.tbl_deep_extend("force", options, opts or {})

  local base = M.get_base(model)
  return require("spectrolite.models." .. base .. "." .. model).print(
    color,
    options
  )
end

---Replace selected area with `str`.
---Meant to be used only with validated selection from `read()`.
---@param selection Spectrolite.Selection Selection received from `read()`
---@param str string Color in CSS-like format
---@return boolean? status `true` if written, `false` if tried, `nil` if missing arguments
function M.write(selection, str)
  local utils = require("spectrolite.utils.buffer")

  local status = utils.write(selection, str)
  if not status then
    vim.notify("Cannot write to buffer", vim.log.levels.WARN)
  end

  return status
end

---Convert between color models.
---@param str string Color in CSS-like format.
---@param model_out Spectrolite.Models Color model to convert into
---@param model_in? Spectrolite.Models Color model to convert from
---@param opts? Spectrolite.Config Temporary config overrides
---@return string? str_out Color in CSS-like format
---@return Spectrolite.Models? model_in Echoed from input or auto-defined
function M.convert(str, model_out, model_in, opts)
  local color
  color, model_in = M.parse(str, model_in)
  if not color or not model_in then
    return nil
  end

  if model_in ~= model_out then
    local normal = M.normalize(model_in, color)

    -- local base_in = M.get_base(model_in)
    -- local base_out = M.get_base(model_out)
    -- normal = M.rebase(base_in, base_out, normal)

    color = M.denormalize(model_out, normal)
  end

  local options = require("spectrolite.config").config
  options = vim.tbl_deep_extend("force", options, opts or {})

  color = M.format(model_out, color, options)
  local str_out = M.print(model_out, color, options)

  return str_out
end

---Override default configuration.
---@param opts? Spectrolite.Config table
function M.setup(opts)
  require("spectrolite.config").setup(opts)
end

return M
