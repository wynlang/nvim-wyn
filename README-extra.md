# Wyn Language Support for Neovim

Official Neovim plugin for the Wyn programming language.

## Features

- **Syntax Highlighting** - Full syntax highlighting for Wyn code
- **LSP Integration** - Full Language Server Protocol support
- **Auto-completion** - Context-aware completions
- **Go to Definition** - Jump to symbol definitions
- **Find References** - Find all usages of a symbol
- **Hover Information** - Type information on hover
- **Rename Symbol** - Safe refactoring
- **Format Document** - Auto-format code
- **Diagnostics** - Real-time error checking

## Requirements

- Neovim 0.8+
- [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig)
- Wyn compiler installed and in PATH

## Installation

### Using lazy.nvim

```lua
{
  'wyn-lang/wyn.nvim',
  ft = 'wyn',
  dependencies = { 'neovim/nvim-lspconfig' },
  config = function()
    require('wyn').setup()
  end
}
```

### Using packer.nvim

```lua
use {
  'wyn-lang/wyn.nvim',
  ft = 'wyn',
  requires = { 'neovim/nvim-lspconfig' },
  config = function()
    require('wyn').setup()
  end
}
```

### Using vim-plug

```vim
Plug 'neovim/nvim-lspconfig'
Plug 'wyn-lang/wyn.nvim'

lua << EOF
require('wyn').setup()
EOF
```

## Configuration

### Basic Setup

```lua
require('wyn').setup()
```

### Custom Configuration

```lua
require('wyn').setup({
  cmd = '/custom/path/to/wyn',  -- Custom wyn executable path
  on_attach = function(client, bufnr)
    -- Your custom LSP keybindings
    local opts = { buffer = bufnr, noremap = true, silent = true }
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set('n', '<leader>f', vim.lsp.buf.format, opts)
  end,
  capabilities = require('cmp_nvim_lsp').default_capabilities()
})
```

## Usage

1. Open any `.wyn` file
2. Plugin activates automatically
3. LSP features available immediately

## Keybindings

Default LSP keybindings (if using nvim-lspconfig defaults):

- `gd` - Go to definition
- `K` - Hover information
- `gr` - Find references
- `<leader>rn` - Rename symbol
- `<leader>f` - Format document
- `[d` / `]d` - Navigate diagnostics

## Troubleshooting

**LSP not starting?**
```bash
# Test wyn LSP manually
wyn lsp

# Check if wyn is in PATH
which wyn
```

**Syntax highlighting not working?**
```vim
:set filetype=wyn
```

**Check LSP status:**
```vim
:LspInfo
```

## License

MIT
