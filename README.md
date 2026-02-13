# Wyn for Neovim

Syntax highlighting and language server support for [Wyn](https://wynlang.com).

## Features

- Syntax highlighting for all keywords, 27 modules, operators, string interpolation
- LSP integration via `wyn lsp` — completions, hover, go-to-definition, references, rename, format
- Filetype detection for `.wyn` files
- Smart indentation, code folding, comment toggling

## Install

### lazy.nvim

```lua
{ "wynlang/nvim-wyn", ft = "wyn" }
```

### packer.nvim

```lua
use "wynlang/nvim-wyn"
```

### vim-plug

```vim
Plug 'wynlang/nvim-wyn'
```

### Manual

```bash
cp -r syntax ftdetect ftplugin ~/.config/nvim/
```

## LSP

Add to your `init.lua`:

```lua
-- Using nvim-lspconfig
local lspconfig = require('lspconfig')
local configs = require('lspconfig.configs')

if not configs.wyn then
  configs.wyn = {
    default_config = {
      cmd = {'wyn', 'lsp'},
      filetypes = {'wyn'},
      root_dir = lspconfig.util.root_pattern('wyn.toml', '.git'),
    },
  }
end

lspconfig.wyn.setup{}
```

Or without lspconfig:

```lua
vim.api.nvim_create_autocmd("FileType", {
  pattern = "wyn",
  callback = function()
    vim.lsp.start({
      name = "wyn",
      cmd = {"wyn", "lsp"},
      root_dir = vim.fs.dirname(vim.fs.find({"wyn.toml", ".git"}, {upward = true})[1]),
    })
  end,
})
```

Make sure `wyn` is in your PATH (`wyn install`).

LSP provides:
- **Completions** — all keywords, 27 modules with method hints, triggered by `.`
- **Hover** — type information
- **Go to Definition** — jump to function/struct definitions
- **Find References** — find all usages
- **Rename** — rename symbols across files
- **Format** — format document

## Keymaps

Suggested additions to your config:

```lua
vim.api.nvim_create_autocmd("FileType", {
  pattern = "wyn",
  callback = function()
    vim.keymap.set("n", "<F5>", ":!wyn run %<CR>", {buffer = true})
    vim.keymap.set("n", "<F6>", ":!wyn check %<CR>", {buffer = true})
  end,
})
```

## Highlighted

| Category | Tokens |
|----------|--------|
| Keywords | `fn var const struct enum impl trait type pub import export module` |
| Flow | `return break continue spawn await if else match while for in` |
| Modifiers | `mut` |
| Types | `int float string bool void ResultInt OptionInt` |
| Modules | `File System Terminal HashMap Math Path DateTime Json Regex Csv Http Net Db Task Gui Audio StringBuilder Crypto Encoding Os Uuid Log Process Test Url` |
| Constants | `true false None Some Ok Err` |

## Example

```wyn
struct Vec2 {
    x: int
    y: int

    fn mag_sq(self) -> int {
        return self.x * self.x + self.y * self.y
    }
}

fn main() -> int {
    var v = Vec2{x: 3, y: 4}
    var squares = [i * i for i in 0..10]
    println(v.mag_sq().to_string())
    return 0
}
```

## Links

- [Wyn Language](https://github.com/wynlang/wyn)
- [Documentation](https://github.com/wynlang/wyn/tree/main/docs)
- [wynlang.com](https://wynlang.com)
