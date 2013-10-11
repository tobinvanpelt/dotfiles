" Tobin's vimrc file 
"
" Special Note: To profile see: http://stackoverflow.com/a/12216578/670654
"
" :profile start profile.log
" :profile func *
" :profile file *
" (do work)
" :profile pause
" :noautocmd qall!

if !has('unix')
    let $HOME="C:/home/tobin"
endif


" disbale plugins
let g:pathogen_disabled = ['vim-semicolon']


" INFECT the pathogen - wa ha ha ha
call pathogen#infect()


" Colors
set t_Co=256
colorscheme desert256
syntax on

if has("gui_running")
    if has("gui_win32")
        "set guifont=Lucida_Console:h9:cANSI
        set guifont=Consolas\ for\ Powerline\ FixedD:h9

        set guioptions-=m
        set guioptions-=T
        set guioptions-=r

        au GUIEnter * simalt ~x
    endif                              
endif

" change Searh highligh
"highlight Search cterm=bold ctermfg=None ctermbg=222
highlight Search cterm=bold ctermfg=None ctermbg=blue

" map some leaders quick keys
"nnoremap <silent> <leader>c :set cursorline! <CR>
nnoremap <silent> <leader>c :call SetCursorline()<CR>
nnoremap <silent> <leader>h :set hls! <CR>
nnoremap <silent> <leader>= :set paste! <CR>

let g:cursorline = 1
"autocmd WinEnter,BufEnter * setlocal cursorline
"autocmd WinLeave,BufLeave * setlocal nocursorline
autocmd WinEnter,BufEnter * call UpdateCursorLine()
autocmd WinLeave,BufLeave * setlocal nocursorline


func! SetCursorline()
    setlocal cursorline!
    if g:cursorline
        let g:cursorline = 0
    else
        let g:cursorline = 1
    end
endfunc


func! UpdateCursorLine()
    if g:cursorline
        setlocal cursorline
    endif
endfunc
    


highlight SignColumn ctermbg=None
highlight LineNr ctermfg=229 ctermbg=None
highlight CursorLineNr ctermfg=208 ctermbg=238 
highlight CursorLine ctermfg=None ctermbg=238

func! CursorInsertHighlight()
    highlight CursorLine ctermbg=235
    highlight CursorLineNr ctermbg=235
endfunc

func! CursorNormalHighlight()
    highlight CursorLine ctermbg=238
    highlight CursorLineNr ctermbg=238
endfunc

autocmd InsertEnter * call CursorInsertHighlight()
autocmd InsertLeave * call CursorNormalHighlight()


" for copying to OSX clipboard
vmap <C-x> :!pbcopy<CR>  
vmap <C-c> :w !pbcopy<CR><CR> 


" this crazieness changes cursor on insert when in tmux
if has('unix')
    if exists('$TMUX')
      let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
      let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=2\x7\<Esc>\\"
    else
      let &t_SI = "\<Esc>]50;CursorShape=1\x7"
      let &t_EI = "\<Esc>]50;CursorShape=2\x7"
    endif
endif

" colored right edge
highlight ColorColumn ctermbg=238
set colorcolumn=80

set hlsearch
set nocompatible

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

set history=50		" keep 50 lines of command line history
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set incsearch		" do incremental searching

" For Win32 GUI: remove 't' flag from 'guioptions': no tearoff menu entries
" let &guioptions = substitute(&guioptions, "t", "", "g")

" Don't use Ex mode, use Q for formatting
map Q gq

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

" In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
  set mouse=a
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  " Also don't do it when the mark is in the first line, that is the default
  " position when opening a file.
  autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif

  augroup END

else

  set autoindent		" always set autoindenting on

endif " has("autocmd")

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
		  \ | wincmd p | diffthis
endif


set ai
set ts=4
set sts=4
set et
set sw=4
set textwidth=79

set ofu=syntaxcomplete#Complete
autocmd ColorScheme * highlight Pmenu guibg=brown gui=bold
set completeopt+=longest
"set number
set incsearch

" line numbers
autocmd FileType vim set number
autocmd FileType python set number
autocmd FileType javascript set number
autocmd FileType coffee set number
autocmd FileType html set number
autocmd FileType css set number

" HTML (tab width 2 chr, no wrapping)
autocmd FileType html setlocal sw=2
autocmd FileType html setlocal ts=2
autocmd FileType html setlocal sts=2
autocmd FileType html setlocal textwidth=0

" XHTML (tab width 2 chr, no wrapping)
autocmd FileType xhtml setlocal sw=2
autocmd FileType xhtml setlocal ts=2
autocmd FileType xhtml setlocal sts=2
autocmd FileType xhtml setlocal textwidth=0

" CSS (tab width 2 chr, wrap at 79th char)
autocmd FileType css setlocal sw=2
autocmd FileType css setlocal ts=2
autocmd FileType css setlocal sts=2

" auto completes
autocmd FileType python set omnifunc=pythoncomplete#Complete
autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
autocmd FileType css set omnifunc=csscomplete#CompleteCSS

set hidden
set virtualedit=all
set wildmenu

" move cursor to other window 
noremap <silent> ,h :wincmd h<cr>
noremap <silent> ,j :wincmd j<cr>
noremap <silent> ,k :wincmd k<cr>
noremap <silent> ,l :wincmd l<cr>

" close window 
noremap <silent> ,cj :wincmd j<cr>:close<cr>
noremap <silent> ,ck :wincmd k<cr>:close<cr>
noremap <silent> ,ch :wincmd h<cr>:close<cr>
noremap <silent> ,cl :wincmd l<cr>:close<cr>

" close current window
noremap <silent> ,cc :close<cr>
noremap <silent> ,ml <C-W>L
noremap <silent> ,mk <C-W>K
noremap <silent> ,mh <C-W>H
noremap <silent> ,mj <C-W>J


" a few settings for swap and backup
set backup
set writebackup
set swapfile

if has('unix')
    set backupdir=~/.vim/tmp/backup//
    set directory=~/.vim/tmp/swap//
else
    set backupdir=~/.dot/vim/tmp/backup//
    set directory=~/.dot/vim/tmp/swap//
endif

call system('rm -f ~/.vim/tmp/backup/*\~(D)')

" -----------------------------------------------------------------------------

" quick vimrc access
command! Vimrc edit ~/.vimrc 

" clear search when refreshing
nnoremap <silent> <C-l> :nohl<CR><C-l>

" easytagsder
let g:easytags_dynamic_files = 2

" nerdtree
nmap <silent> <leader>p :NERDTreeToggle<CR>
let NERDTreeIgnore = ['\.pyc$']

" syntastic
let g:syntastic_check_on_open=1 
let g:syntastic_loc_list_height=4
let g:syntastic_javascript_checker='jsl'

" *.ipy files
autocmd BufNewFile,BufRead *.ipy set filetype=python

" coffee-script
autocmd FileType coffee setlocal sw=2
autocmd FileType coffee setlocal ts=2
autocmd FileType coffee setlocal sts=2

let coffee_make_options = '--bare'
"au BufWritePost *.coffee silent CoffeeMake! -b | cwindow | redraw!
let coffee_compile_vert = 1
au BufNewFile,BufReadPost *.coffee setl foldmethod=indent nofoldenable
au BufNewFile,BufReadPost *.coffee setl shiftwidth=2 expandtab

command! Watch CoffeeCompile watch vert
command! WatchBottom wincmd J | Watch

" indentation for coffeescript
au BufNewFile,BufReadPost *.coffee setl foldmethod=indent nofoldenable
au BufNewFile,BufReadPost *.coffee setl shiftwidth=2 expandtab


" ctrlp

"let g:ctrlp_cmd = 'CtrlPBuffer'
let g:ctrlp_arg_map = 1
let g:ctrlp_dotfiles = 1
let g:ctrlp_custom_ignore= '\.js$\|\.pyc$'
command! ShowJS let g:ctrlp_custom_ignore= '\.pyc$' | :ClearAllCtrlPCaches
command! HideJS let g:ctrlp_custom_ignore= '\.js$\|\.pyc$' | :ClearAllCtrlPCaches

" keeps ctrlp away from build dirs
let g:ctrlp_mruf_exclude = '\/build\/'

nnoremap <silent> <leader>f :CtrlP<CR>
nnoremap <silent> <leader>b :CtrlPBuffer<CR>
nnoremap <silent> <leader>m :CtrlPMRUFiles<CR>

" defualt split locations
set splitbelow
set splitright


" flake 8
let g:syntastic_python_checkers=['flake8']
let g:syntastic_python_flake8_args='--ignore=E126,E127,E128,E701,E702'

" python mode
" turn off lint, breakpoint, and run
let g:pymode_lint=0
let g:pymode_breakpoint=0
let g:pymode_run=0


" nose compiler 
"autocmd BufNewFile,BufRead *.py compiler nose

" --- tagbar ---
let g:tagbar_sort = 0
let g:tagbar_autoclose = 1

" used for setting cursorline when moving to tagbar window
"function! OpenTagbar()
"    setlocal nocursorline
"    call tagbar#OpenWindow('fj')
"    setlocal cursorline
"endfunction

"nnoremap <silent> <leader>t :call OpenTagbar()<CR>

nnoremap <silent> <leader>t :TagbarToggle<CR>
"nnoremap <silent> <leader>T :TagbarClose<CR>
                               
" powerline
if has('unix')
    let g:Powerline_symbols = 'unicode'
else
    let g:Powerline_symbols = 'fancy'
endif

call Pl#Theme#RemoveSegment('fileencoding')
call Pl#Theme#RemoveSegment('fileformat')

set nocompatible   " Disable vi-compatibility
set laststatus=2   " Always show the statusline
set encoding=utf-8 " Necessary to show unicode glyphs


" pydoc.vim
let g:pydoc_cmd = 'python -m pydoc'
let g:pydoc_open_cmd = 'vsplit'
let g:pydoc_highlight = 0 


" supertab
let g:SuperTabDefaultCompletionType = "context"
"let g:SuperTabContextDefaultCompletionType="<c-x><c-k>"
let g:SuperTabLongestEnhanced = 1
let g:SuperTabLongestHighlight = 1
let g:SuperTabClosePreviewOnPopupClose = 1


" TODO: move this to its own file
" XML formatter
function! DoFormatXML() range
    " Save the file type
    let l:origft = &ft

    " Clean the file type
    set ft=

    " Add fake initial tag (so we can process multiple top-level elements)
    exe ":let l:beforeFirstLine=" . a:firstline . "-1"
    if l:beforeFirstLine < 0
        let l:beforeFirstLine=0
    endif
    exe a:lastline . "put ='</PrettyXML>'"
    exe l:beforeFirstLine . "put ='<PrettyXML>'"
    exe ":let l:newLastLine=" . a:lastline . "+2"
    if l:newLastLine > line('$')
        let l:newLastLine=line('$')
    endif

    " Remove XML header
    exe ":" . a:firstline . "," . a:lastline . "s/<\?xml\\_.*\?>\\_s*//e"

    " Recalculate last line of the edited code
    let l:newLastLine=search('</PrettyXML>')

    " Execute external formatter
    exe ":silent " . a:firstline . "," . l:newLastLine . "!xmllint --noblanks --format --recover -"

    " Recalculate first and last lines of the edited code
    let l:newFirstLine=search('<PrettyXML>')
    let l:newLastLine=search('</PrettyXML>')
    
    " Get inner range
    let l:innerFirstLine=l:newFirstLine+1
    let l:innerLastLine=l:newLastLine-1

    " Remove extra unnecessary indentation
    exe ":silent " . l:innerFirstLine . "," . l:innerLastLine "s/^  //e"

    " Remove fake tag
    exe l:newLastLine . "d"
    exe l:newFirstLine . "d"

    " Put the cursor at the first line of the edited code
    exe ":" . l:newFirstLine

    " Restore the file type
    exe "set ft=" . l:origft
endfunction
command! -range=% FormatXML <line1>,<line2>call DoFormatXML()

nmap <silent> <leader>x :%FormatXML<CR>
vmap <silent> <leader>x :FormatXML<CR>

" UltiSnips 
let g:UltiSnipsSnippetsDir = "~/.vim/snippets"
let g:UltiSnipsSnippetDirectories=["UltiSnips", "snippets"]

" enable project vimrc files
" set exrc
" set secure
