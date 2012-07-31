
"============
"Syntax for asfermi
"============
syn match PreProc "!\a\+"
syn keyword WarningMsg EXIT
syn match Comment "//.*$" oneline
syn region Comment start="/\*" end="\*/"
syn match DiffText "@P\d"
syn match DiffText "\A\zsP\d\ze\A" 
syn match DiffText "\A\zspt\ze\A"
syn match Identifier "\A\zsR\d\{1,2}"
syn match Constant "\A\zs\d\+"  "integer numbers
syn match Constant "\A\zs0[xX]\x\+\ze\A" "hex numbers
syn match Constant "SR_\(\a\|_\)\+"
