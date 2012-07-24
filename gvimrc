colorscheme desert
set transparency=5
set go+=c
set go-=T

" full screen
command! FullScreen :set fu
command! NoFullScreen :set nofu

" set colors for makegreen
hi GreenBar term=reverse ctermfg=white ctermbg=green guifg=white guibg=green
hi RedBar   term=reverse ctermfg=white ctermbg=red guifg=white guibg=red
