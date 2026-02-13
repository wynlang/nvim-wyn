" Wyn syntax highlighting for Neovim
" Language: Wyn
" Maintainer: AO Design Inc

if exists("b:current_syntax")
  finish
endif

" Keywords
syn keyword wynKeyword fn var const struct enum impl trait type pub import export module
syn keyword wynConditional if else match case
syn keyword wynRepeat while for in
syn keyword wynStatement return break continue spawn await
syn keyword wynBoolean true false
syn keyword wynConstant None Some Ok Err
syn keyword wynSelf self super root
syn keyword wynModifier mut

" Types
syn keyword wynType int float string bool void ResultInt ResultString OptionInt OptionString

" Built-in modules (25 modules)
syn keyword wynModule File System Terminal HashMap HashSet Math Path DateTime Json Regex
syn keyword wynModule Url Test Task Db Http Net Gui Audio StringBuilder
syn keyword wynModule Crypto Encoding Os Uuid Log Process

" Numbers
syn match wynNumber "\<\d\+\>"
syn match wynNumber "\<\d\+\.\d\+\>"
syn match wynNumber "\<0x[0-9a-fA-F]\+\>"

" Strings
syn region wynString start='"' end='"' contains=wynEscape,wynInterp
syn match wynEscape contained "\\[nrt\\\"0]"
syn match wynEscape contained "\\x[0-9a-fA-F]\{2\}"
syn region wynInterp contained start='\${' end='}' contains=TOP

" Comments
syn match wynComment "//.*$" contains=wynTodo
syn keyword wynTodo contained TODO FIXME XXX NOTE HACK

" Function definitions
syn match wynFunction "\<fn\s\+\zs\w\+"

" Struct/enum/trait names
syn match wynTypeDef "\<struct\s\+\zs\w\+"
syn match wynTypeDef "\<enum\s\+\zs\w\+"
syn match wynTypeDef "\<trait\s\+\zs\w\+"

" Method calls
syn match wynMethodCall "\.\zs\w\+\ze("

" Operators
syn match wynOperator "[+\-*/%=<>!&|^~?]"
syn match wynOperator "\.\."
syn match wynOperator "->"
syn match wynOperator "=>"

" Highlighting
hi def link wynKeyword Keyword
hi def link wynConditional Conditional
hi def link wynRepeat Repeat
hi def link wynStatement Statement
hi def link wynBoolean Boolean
hi def link wynConstant Constant
hi def link wynSelf Special
hi def link wynModifier StorageClass
hi def link wynType Type
hi def link wynModule Structure
hi def link wynNumber Number
hi def link wynString String
hi def link wynEscape SpecialChar
hi def link wynInterp Special
hi def link wynComment Comment
hi def link wynTodo Todo
hi def link wynFunction Function
hi def link wynTypeDef TypeDef
hi def link wynMethodCall Function
hi def link wynOperator Operator

let b:current_syntax = "wyn"
