" Vim syntax file
" Language: FHEM config files

if exists("b:current_syntax")
  finish
endif

syn case ignore

" Match comments
syn match fhemComment "#.*$"
syn match fhemComment "^#.*$"

" Match FHEM device names
"syn match fhemAttribute "\b\w\+\b"
"syn match fhemAttribute "\<\(\w\|.\|:\)\+\>"
"syn region fhemKak start="^\w+" end="$" contains=fhemAttribute
"syn match fhemAttribute "\<\(\w\|.\|:\)\+\>" contained
syn match fhemDevice "\s\S\+" contained nextgroup=fhemArgument
syn match fhemArgument "\s\S\+" contained nextgroup=fhemValue
syn match fhemDeviceDef "\s\S\+" contained nextgroup=fhemArgumentDef
syn match fhemArgumentDef "\s\S\+" contained nextgroup=fhemValue

" Match FHEM attribute names and values
"syn match fhemAttribute "\<\w\+\>" contains=fhemValue
"syn match fhemValue 
syn match fhemValue /\s.+/ contained
"syn match fhemValue /"[^"]*"/ 

" Match FHEM commands
syn keyword fhemDefine define defmod modify copy delete nextgroup=fhemDeviceDef
syn keyword fhemCommand set get attr setuuid deletereading deleteattr setdefaultaddr setreading setstate trigger nextgroup=fhemDevice

" Set the colors for each type of syntax element
hi def link fhemComment Comment 
hi def link fhemDefine Keyword
hi def link fhemDevice Identifier
hi def link fhemDeviceDef Special
hi def link fhemValue String
hi def link fhemCommand Constant
hi def link fhemArgument String
hi def link fhemArgumentDef PreProc
