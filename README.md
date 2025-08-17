# Spectrolite for Neovim

A color converter plugin.

![Example](https://raw.githubusercontent.com/shushtain/spectrolite.nvim/refs/heads/main/example.gif)

> Colored dots are from a separate plugin. CursorLine color change is described below, in [Usage: Advanced](#advanced).

## Features

- Converts between HEX, RGB, HSL, and HXL/Cubehelix color models.
- Supports alpha channel for all the color models listed above.
- Has extensive formatting options based on CSS-like representation.

## Setup

Setup is optional and used only to override default configuration.

Here is an example using Lazy, with all the defaults:

```lua
return {
  "shushtain/spectrolite.nvim",
  config = function()
    require("spectrolite").setup({
      hexa = {
        uppercase = false,
        symbol = true,
      },
      hsla = {
        round = { h = 0, s = 0, l = 0, a = 2 },
        percents = { s = false, l = false, a = false },
        separators = { regular = " ", alpha = " / " },
      },
      hxla = {
        round = { h = 0, x = 0, l = 0, a = 2 },
        percents = { x = false, l = false, a = false },
        separators = { regular = " ", alpha = " / " },
      },
      rgba = {
        round = { r = 0, g = 0, b = 0, a = 2 },
        percents = { a = false },
        separators = { regular = " ", alpha = " / " },
      },
    })
  end
}
```

## Usage

### Basic

If you just want to convert colors within the buffer, select the color and call `:Spectrolite`. This will prompt you to select the target color model (what to convert into). The current model will be defined automagically. If you want to skip model selection, use `:Spectrolite <model>`, like `:Spectrolite hsl`.

You could also create keymaps (none are set by default):

```lua
vim.keymap.set({ "n", "x" }, "<leader>cc", "<cmd> Spectrolite <CR>")
vim.keymap.set({ "n", "x" }, "<leader>ch", "<cmd> Spectrolite hex <CR>")
vim.keymap.set({ "n", "x" }, "<leader>cs", "<cmd> Spectrolite hsl <CR>")
vim.keymap.set({ "n", "x" }, "<leader>cx", "<cmd> Spectrolite hxl <CR>")
vim.keymap.set({ "n", "x" }, "<leader>cr", "<cmd> Spectrolite rgb <CR>")
```

With `"n"` the plugin will be able to run on the last converted color instead of having to select it again manually. If you don't want this feature, set only `"x"` (for visual mode).

### Advanced

For advanced operations, refer to `:h spectrolite-functions`.

You can use this plugin to extend capabilities of your editor's UI, create snippets that convert colors, send colors to other plugins, etc. Here is a silly example of changing CursorLine:

```lua
vim.keymap.set("x", "<leader>c/", function()
  local sp = require("spectrolite")

  -- read from selection
  local str = sp.read()
  if not str then return end

  -- convert into HEX
  local color = sp.convert(str, "hex")
  if not color then return end

  -- update CursorLine
  vim.api_set_hl(0, "CursorLine", { bg = color })
end)
```

## Credits

- [Dave Green's Cubehelix](https://people.phy.cam.ac.uk/dag9/CUBEHELIX/#Paper)
- [NTBBloodbath's Color Converter](https://github.com/NTBBloodbath/color-converter.nvim)
