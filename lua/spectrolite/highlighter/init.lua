local M = {}

M._models = { "hexa", "hex", "hsla", "hsl", "hxla", "hxl", "rgba", "rgb" }

---Toggle color highlighting.
---@param opts? Spectrolite.Config Temporary config overrides
function M.toggle(opts)
  local is_enabled = vim.tbl_get(vim.g.spectrolite, "highlighter", "is_enabled")
  if is_enabled then
    M.disable()
  else
    M.enable(opts)
  end
end

---Enable color highlighting.
---@param opts? Spectrolite.Config Temporary config overrides
function M.enable(opts)
  local state = vim.g.spectrolite
  state.highlighter = state.highlighter or {}

  state.highlighter.ns = vim.tbl_get(state, "highlighter", "ns")
    or vim.api.nvim_create_namespace("SpectroliteHighlighter")
  state.highlighter.group = vim.tbl_get(state, "highlighter", "group")
    or vim.api.nvim_create_augroup("SpectroliteHighlighter", { clear = true })

  M._highlight(opts)

  vim.api.nvim_create_autocmd({ "CursorHold", "BufWinEnter", "InsertLeave" }, {
    group = state.highlighter.group,
    callback = function()
      M._highlight(opts)
    end,
  })

  vim.api.nvim_create_autocmd({ "BufWinLeave" }, {
    group = state.highlighter.group,
    callback = function()
      M._clear()
    end,
  })

  state.highlighter.is_enabled = true
  vim.g.spectrolite = state
end

---Disable color highlighting.
function M.disable()
  local state = vim.g.spectrolite
  state.highlighter = state.highlighter or {}

  M._clear()

  if state.highlighter.group then
    vim.api.nvim_del_augroup_by_id(state.highlighter.group)
    state.highlighter.group = nil
  end

  state.highlighter.is_enabled = false
  vim.g.spectrolite = state
end

---@private
function M._highlight(opts)
  local state = vim.g.spectrolite
  state.highlighter = state.highlighter or {}
  if not state.highlighter.ns then
    return
  end

  M._clear()

  local options = require("spectrolite.config").config
  options = vim.tbl_deep_extend("force", options, opts or {})
  local models = vim.tbl_get(options, "highlighter", "limit_models")
  if not models then
    models = M._models
  end

  local patterns = {}
  for _, model in ipairs(models) do
    local base = require("spectrolite").get_base(model)
    local pattern =
      require("spectrolite.models." .. base .. "." .. model).capture
    patterns[model] = pattern
  end

  local buf = vim.api.nvim_get_current_buf()
  local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)

  for row, line in ipairs(lines) do
    for model, pattern in pairs(patterns) do
      local scol = 1
      while true do
        local spos, epos = line:find(pattern, scol)
        if not spos or not epos then
          break
        end

        local str = line:match(pattern, spos)
        local bg, fg = M._get_colors(str, model)
        if bg then
          local hl = "Spectrolite_" .. bg:gsub("#", "")
          if fg then
            vim.api.nvim_set_hl(0, hl, { bg = bg, fg = fg })
          end
          vim.api.nvim_buf_set_extmark(
            buf,
            state.highlighter.ns,
            row - 1,
            spos - 1,
            {
              end_col = epos,
              hl_group = hl,
            }
          )
        end
        scol = epos + 1
      end
    end
  end
end

---@private
function M._clear()
  local state = vim.g.spectrolite
  state.highlighter = state.highlighter or {}

  if state.highlighter.ns then
    local buf = vim.api.nvim_get_current_buf()
    vim.api.nvim_buf_clear_namespace(buf, state.highlighter.ns, 0, -1)
  end
end

---@private
function M._get_colors(str, model)
  local spectrolite = require("spectrolite")
  local quiet = { quiet = true, hexa = { symbol = true } }

  local color_in = spectrolite.parse(str, model, quiet)
  if not color_in then
    return nil
  end

  local normal = spectrolite.normalize(model, color_in, quiet)
  local hex = spectrolite.denormalize("hex", normal, quiet)
  local bg = spectrolite.print("hex", hex, quiet)

  local hl =
    vim.api.nvim_get_hl(0, { name = "Spectrolite_" .. bg:gsub("#", "") })
  if hl.bg then
    return bg, nil
  end

  local fg
  local hxl = spectrolite.denormalize("hxl", normal, quiet)
  if hxl.l < 40 then
    fg = "#ffffff"
  else
    fg = "#000000"
  end

  return bg, fg
end

return M
