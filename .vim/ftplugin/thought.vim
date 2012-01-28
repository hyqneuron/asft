imap <C-P> ===============================<Esc>21hR
syntax region MyMenu start="^=" end="$" oneline
syntax match NumPost "\d\+\."
syntax match NumIndex "^\d\+\."
highlight NumIndex ctermbg=red ctermfg=white guibg=red guifg=white
highlight NumPost ctermbg=green ctermfg=white guibg=green guifg=white
highlight MyMenu ctermbg=yellow ctermfg=black guibg=yellow guifg=black
