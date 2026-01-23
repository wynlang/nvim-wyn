" Vim syntax file
" Language: Wyn
" Maintainer: Wyn Team
" Latest Revision: 2026-01-23

if exists("b:current_syntax")
  finish
endif

" Keywords
syn keyword wynKeyword fn var const struct enum impl trait type pub import module
syn keyword wynConditional if else match case
syn keyword wynRepeat while for
syn keyword wynStatement return break continue
syn keyword wynBoolean true false
syn keyword wynConstant None Some Ok Err
syn keyword wynSelf self super root

" Types
syn keyword wynType int float string bool void
syn match wynType "\<[A-Z][a-zA-Z0-9_]*\>"

" Comments
syn keyword wynTodo contained TODO FIXME XXX NOTE
syn match wynComment "//.*$" contains=wynTodo
syn region wynComment start="/\*" end="\*/" contains=wynTodo

" Strings
syn region wynString start=+"+ skip=+\\\\\|\\"+ end=+"+ contains=wynStringInterpolation
syn region wynString start=+'+ skip=+\\\\\|\\'+ end=+'+
syn match wynStringInterpolation "\${[^}]*}" contained

" Numbers
syn match wynNumber "\<\d\+\>"
syn match wynFloat "\<\d\+\.\d\+\>"
syn match wynHex "\<0[xX][0-9a-fA-F_]\+\>"
syn match wynBinary "\<0[bB][01_]\+\>"

" Functions
syn match wynFunction "\<[a-zA-Z_][a-zA-Z0-9_]*\>\s*("me=e-1

" Operators
syn match wynOperator "[-+*/%=<>!&|^~]"
syn match wynOperator "::"
syn match wynOperator "->"

" Highlighting
hi def link wynKeyword Keyword
hi def link wynConditional Conditional
hi def link wynRepeat Repeat
hi def link wynStatement Statement
hi def link wynBoolean Boolean
hi def link wynConstant Constant
hi def link wynSelf Special
hi def link wynType Type
hi def link wynComment Comment
hi def link wynTodo Todo
hi def link wynString String
hi def link wynStringInterpolation Special
hi def link wynNumber Number
hi def link wynFloat Float
hi def link wynHex Number
hi def link wynBinary Number
hi def link wynFunction Function
hi def link wynOperator Operator

let b:current_syntax = "wyn"
