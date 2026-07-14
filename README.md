# Wyn for Neovim

Syntax highlighting and language-server support for [Wyn](https://wynlang.com).

## Features

- **Syntax highlighting** — all keywords, built-in modules, types, operators, string interpolation, comments
- **LSP** via `wyn lsp` — live diagnostics (type-check only, never runs your code), completions, hover, go-to-definition, find references, rename
- **Filetype detection** for `.wyn` and `.🐉` files
- Smart indentation, code folding, comment toggling (`gcc`/`gc` with a commentstring)

## Install

### lazy.nvim

```lua
{
  "wynlang/nvim-wyn",
  ft = "wyn",
  config = function() require("wyn").setup() end,
}
```

### packer.nvim

```lua
use { "wynlang/nvim-wyn", config = function() require("wyn").setup() end }
```

### vim-plug

```vim
Plug 'wynlang/nvim-wyn'
" then, in lua:  require('wyn').setup()
```

### Manual

```bash
cp -r syntax ftdetect ftplugin lua ~/.config/nvim/
```

Syntax highlighting works with **no configuration**. Calling `require('wyn').setup()`
additionally wires up the language server.

## LSP setup

```lua
require("wyn").setup()
```

That's it. `setup()`:

- works **with or without** [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig)
  — if lspconfig is installed it registers the `wyn` server there (so `:LspInfo`
  works); otherwise it uses Neovim's built-in `vim.lsp.start` and auto-starts the
  server when you open a `.wyn` file,
- resolves the project root from the nearest `wyn.toml` or `.git`,
- requires the `wyn` binary on your `PATH` (install with `wyn install`).

Options:

```lua
require("wyn").setup({
  cmd = "wyn",          -- path to the wyn binary (default: "wyn")
  auto_start = true,    -- start the LSP on FileType wyn (built-in path only)
  on_attach = function(client, bufnr) end,  -- your keymaps, etc.
  capabilities = require("cmp_nvim_lsp").default_capabilities(),  -- optional
})
```

The language server provides:

- **Diagnostics** — errors/warnings from `wyn check` as you type (it type-checks
  only; it never compiles-and-runs your program)
- **Completions** — keywords, modules, and symbols (triggered by `.` / `:`)
- **Hover** — symbol info
- **Go to Definition** — jump to function/struct/enum declarations
- **Find References** / **Rename** — across the open files

## Suggested keymaps

```lua
require("wyn").setup({
  on_attach = function(_, bufnr)
    local map = function(k, fn) vim.keymap.set("n", k, fn, { buffer = bufnr }) end
    map("gd", vim.lsp.buf.definition)
    map("gr", vim.lsp.buf.references)
    map("K",  vim.lsp.buf.hover)
    map("<leader>rn", vim.lsp.buf.rename)
  end,
})

-- Build / check the current file
vim.api.nvim_create_autocmd("FileType", {
  pattern = "wyn",
  callback = function()
    vim.keymap.set("n", "<F5>", ":!wyn run %<CR>",   { buffer = true })
    vim.keymap.set("n", "<F6>", ":!wyn check %<CR>", { buffer = true })
  end,
})
```

## Example

```wyn
struct Vec2 {
    x: int
    y: int
}

fn mag_sq(v: Vec2) -> int {
    return v.x * v.x + v.y * v.y
}

fn main() -> int {
    var v = Vec2{x: 3, y: 4}
    println("${mag_sq(v)}")
    return 0
}
```

## Development / tests

The plugin has a headless-Neovim test that loads it with a minimal config and
asserts filetype detection, syntax rules, ftplugin settings, and (when the `wyn`
binary is on `PATH`) LSP attachment:

```bash
bash tests/run.sh          # or: make test
```

CI runs it on Linux and macOS against a freshly built `wyn` compiler. The syntax
keyword and module lists are kept in sync with the compiler
(`src/lexer.c` / `src/module.c`).

## Links

- [Wyn Language](https://github.com/wynlang/wyn)
- [Documentation](https://github.com/wynlang/wyn/tree/main/docs)
- [wynlang.com](https://wynlang.com)
