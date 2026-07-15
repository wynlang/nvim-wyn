" Wyn syntax highlighting for Neovim
" Language: Wyn
" Maintainer: AO Design Inc

if exists("b:current_syntax")
  finish
endif

" Keywords (mirror src/lexer.c keyword_type — kept in sync with the compiler)
syn keyword wynKeyword fn var const struct enum impl trait type pub import export from as extern defer test before_each after_each
syn keyword wynConditional if else match
syn keyword wynRepeat while for in
syn keyword wynStatement return break continue spawn await await_all await_any parallel select channel yield
syn keyword wynOperatorKw and or not
syn keyword wynBoolean true false
syn keyword wynConstant None Some Ok Err
syn keyword wynSelf self super root
syn keyword wynModifier mut

" Types
syn keyword wynType int float string bool void ptr char
syn keyword wynType Option Result OptionInt OptionString OptionFloat OptionBool
syn keyword wynType ResultInt ResultString ResultFloat ResultBool HashMap HashSet

" Built-in functions
syn keyword wynBuiltin println print assert assert_eq range

" Built-in modules (mirror src/module.c is_builtin_module — kept in sync)
syn keyword wynModule math Math File System Path DateTime Time Json Http Regex
syn keyword wynModule Random HashMap HashSet Terminal Color Test Env Net Url Task
syn keyword wynModule Db Gui Audio StringBuilder Crypto Encoding Os Uuid Log Process
syn keyword wynModule Csv Template String Data Socket Ws Args Base64 Toml Bcrypt
syn keyword wynModule Web Smtp App Shared

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
hi def link wynBuiltin Function
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
hi def link wynOperatorKw Operator

let b:current_syntax = "wyn"
