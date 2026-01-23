" Wyn filetype plugin
" Language: Wyn
" Maintainer: Wyn Team

if exists("b:did_ftplugin")
  finish
endif
let b:did_ftplugin = 1

" Comments
setlocal commentstring=//\ %s
setlocal comments=://,s1:/*,mb:*,ex:*/

" Indentation
setlocal autoindent
setlocal smartindent
setlocal shiftwidth=4
setlocal tabstop=4
setlocal expandtab

" Formatting
setlocal formatoptions-=t
setlocal formatoptions+=croql

" Matching
setlocal matchpairs+=<:>

" Keywords
setlocal iskeyword+=:

" Folding
setlocal foldmethod=syntax
setlocal foldlevel=99

" LSP support (if available)
if executable('wyn')
  " Set up LSP client here if using nvim-lspconfig
  " Example:
  " lua << EOF
  " require'lspconfig'.wyn.setup{}
  " EOF
endif
