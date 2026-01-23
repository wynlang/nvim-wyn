# Wyn Language Support for Neovim

Syntax highlighting and language support for the Wyn programming language in Neovim.

## Features

- **Syntax Highlighting** - Full syntax highlighting for Wyn code
- **Filetype Detection** - Automatic detection of `.wyn` files
- **Smart Indentation** - 4-space indentation with auto-indent
- **Comment Support** - Line (`//`) and block (`/* */`) comments
- **Code Folding** - Fold functions and blocks
- **LSP Ready** - Compatible with nvim-lspconfig

## Installation

### Using vim-plug

```vim
Plug 'wyn-lang/nvim-wyn'
```

### Using packer.nvim

```lua
use 'wyn-lang/nvim-wyn'
```

### Manual Installation

```bash
# Copy to Neovim config directory
cp -r nvim-wyn/* ~/.config/nvim/
```

Or for specific directories:

```bash
mkdir -p ~/.config/nvim/syntax
mkdir -p ~/.config/nvim/ftdetect
mkdir -p ~/.config/nvim/ftplugin

cp nvim-wyn/syntax/wyn.vim ~/.config/nvim/syntax/
cp nvim-wyn/ftdetect/wyn.vim ~/.config/nvim/ftdetect/
cp nvim-wyn/ftplugin/wyn.vim ~/.config/nvim/ftplugin/
```

## LSP Integration

To use with Wyn's LSP server:

### Using nvim-lspconfig

Add to your `init.lua`:

```lua
local lspconfig = require('lspconfig')
local configs = require('lspconfig.configs')

-- Define Wyn LSP
if not configs.wyn then
  configs.wyn = {
    default_config = {
      cmd = {'wyn', 'lsp'},
      filetypes = {'wyn'},
      root_dir = lspconfig.util.root_pattern('wyn.toml', '.git'),
      settings = {},
    },
  }
end

-- Setup Wyn LSP
lspconfig.wyn.setup{}
```

### Manual LSP Setup

Add to your `init.vim`:

```vim
if executable('wyn')
  au FileType wyn lua << EOF
    vim.lsp.start({
      name = 'wyn',
      cmd = {'wyn', 'lsp'},
      root_dir = vim.fs.dirname(vim.fs.find({'wyn.toml', '.git'}, { upward = true })[1]),
    })
EOF
endif
```

## Configuration

### Custom Indentation

```vim
" In your init.vim or after/ftplugin/wyn.vim
autocmd FileType wyn setlocal shiftwidth=2 tabstop=2
```

### Custom Key Mappings

```vim
" Build and run current file
autocmd FileType wyn nnoremap <buffer> <F5> :!wyn run %<CR>

" Watch current file
autocmd FileType wyn nnoremap <buffer> <F6> :!wyn watch %<CR>
```

## Features

### Syntax Highlighting

- Keywords: `fn`, `var`, `const`, `struct`, `enum`, etc.
- Types: `int`, `float`, `string`, `bool`, custom types
- Comments: `//` and `/* */`
- Strings: with `${}` interpolation
- Numbers: decimal, hex, binary
- Functions: function names
- Operators: all Wyn operators

### Smart Indentation

- 4-space indentation (configurable)
- Auto-indent on new lines
- Smart indent for blocks

### Code Folding

- Fold functions
- Fold blocks
- Fold comments

## Example

```wyn
// Wyn code with syntax highlighting
fn main() {
    var message = "Hello, Neovim!";
    print(message);
    return 0;
}
```

## Troubleshooting

### Syntax highlighting not working

1. Check filetype: `:set filetype?` (should show `wyn`)
2. Reload syntax: `:set syntax=wyn`
3. Check installation: `:echo $VIMRUNTIME`

### LSP not starting

1. Check wyn is in PATH: `:!which wyn`
2. Test LSP manually: `:!wyn lsp`
3. Check LSP logs: `:LspLog` (if using nvim-lspconfig)

## Links

- [Wyn Language](https://github.com/your-org/wyn-lang)
- [Documentation](https://wyn-lang.org/docs)
- [Examples](https://github.com/your-org/wyn-lang/tree/main/examples)

## License

See LICENSE file in the Wyn repository.
