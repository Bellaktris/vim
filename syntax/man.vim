syntax clear
syntax case ignore

syntax match  manReference       "[a-z_:+-\*][a-z_:+-~!\*<>]\+([1-9][a-z]\=)"
syntax match  manTitle           "^\w.\+([0-9]\+[a-z]\=).*"
syntax match  manSectionHeading  "^[a-z][a-z_ \-:]*[a-z]$"
syntax match  manSubHeading      "^\s\{3\}[a-z][a-z ]*[a-z]$"
syntax match  manOptionDesc      "^\s*[+-][a-z0-9]\S*"
syntax match  manLongOptionDesc  "^\s*--[a-z0-9-]\S*"

syntax include @cppCode runtime! syntax/cpp.vim
syntax match manCFuncDefinition  display "\<\h\w*\>\s*("me=e-1 contained

syntax region manSynopsis start="^SYNOPSIS"hs=s+8 end="^\u\+\s*$"me=e-12 keepend contains=manSectionHeading,@cppCode,manCFuncDefinition
syntax region manSynopsis start="^EXAMPLE"hs=s+7 end="^       [^ ]"he=s-1 keepend contains=manSectionHeading,@cppCode,manCFuncDefinition

hi def link manTitle	         Title
hi def link manSectionHeading  Statement
hi def link manOptionDesc	     Constant
hi def link manLongOptionDesc  Constant
hi def link manReference	     PreProc
hi def link manSubHeading      Function
hi def link manCFuncDefinition Function
