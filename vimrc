" An example for a vimrc file.
"
" Maintainer:	Bram Moolenaar <Bram@vim.org>
" Last change:	2011 Apr 15
"
" To use it, copy it to
"     for Unix and OS/2:  ~/.vimrc
"	      for Amiga:  s:.vimrc
"  for MS-DOS and Win32:  $VIM\_vimrc
"	    for OpenVMS:  sys$login:.vimrc

" THVP - activate pathogen
call pathogen#infect()

" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? "evim"
  finish
endif

" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

if has("vms")
  set nobackup		" do not keep a backup file, use versions instead
else
  set backup		" keep a backup file
endif
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

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
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


" THVP customizations start here

set ai
set ts=4
set sts=4
set et
set sw=4
set textwidth=79

set ofu=syntaxcomplete#Complete
autocmd ColorScheme * highlight Pmenu guibg=brown gui=bold
set completeopt+=longest
set number
set incsearch

" Highlight cursor
highlight CursorLine ctermbg=8 cterm=NONE

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

" map NERDTree to \p
nmap <silent> <Leader>p :NERDTreeToggle<CR>

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
set backupdir=~/.vim/tmp/backup//
set directory=~/.vim/tmp/swap//

silent execute '!rm -f ~/.vim/tmp/backup/*'

" map \c to toggle line highlight
nnoremap <Leader>c :set cursorline! <CR>

autocmd WinEnter * setlocal cursorline
autocmd WinLeave * setlocal nocursorline

autocmd BufEnter * setlocal cursorline
autocmd BufHidden * setlocal cursorline

"autocmd BufWinEnter * setlocal cursorline
"set cursorline

" colored right edge
set colorcolumn=80

" nerdtree
let NERDTreeIgnore = ['\.pyc$']

" syntastic
let g:syntastic_check_on_open=1 
let g:syntastic_loc_list_height=4
let g:syntastic_javascript_checker='jsl'

" coffee-script
autocmd FileType coffee setlocal sw=2
autocmd FileType coffee setlocal ts=2
autocmd FileType coffee setlocal sts=2

let coffee_make_options = '--bare'
au BufWritePost *.coffee silent CoffeeMake! -b | cwindow | redraw!
let coffee_compile_vert = 1
au BufNewFile,BufReadPost *.coffee setl foldmethod=indent nofoldenable
au BufNewFile,BufReadPost *.coffee setl shiftwidth=2 expandtab

command! Watch CoffeeCompile watch vert
command! WatchBottom wincmd J | Watch

" ctrlp
let g:ctrlp_cmd = 'CtrlPBuffer'
let g:ctrlp_arg_map = 1
let g:ctrlp_dotfiles = 0
let g:ctrlp_custom_ignore= '\.js$\|\.pyc$'
command! ShowJS let g:ctrlp_custom_ignore= '\.pyc$' | :ClearAllCtrlPCaches
command! HideJS let g:ctrlp_custom_ignore= '\.js$\|\.pyc$' | :ClearAllCtrlPCaches

" defualt split locations
set splitbelow
set splitright

" powerline
set nocompatible   " Disable vi-compatibility
set laststatus=2   " Always show the statusline
set encoding=utf-8 " Necessary to show unicode glyphs
                                    
" flake 8
let g:syntastic_python_checker_args='--ignore=E70'

" python mode
" turn off lint, breakpoint, and run
let g:pymode_lint=0
let g:pymode_breakpoint=0
let g:pymode_run=0

" Conque shell
function! NoCursorHighlight(term)
    set nocursorline
endfunction

function! CursorHighlight(term)
    set cursorline
endfunction

call conque_term#register_function('after_startup', 'NoCursorHighlight')
call conque_term#register_function('buffer_enter', 'NoCursorHighlight')
call conque_term#register_function('buffer_leave', 'CursorHighlight')

let g:ConqueTerm_StartMessages = 0
let g:ConqueTerm_InsertOnEnter = 1
let g:ConqueTerm_CWInsert = 1
let g:ConqueTerm_CloseOnEnd = 1
let g:ConqueTerm_ReadUnfocused = 1
let g:ConqueTerm_TERM = 'xterm'

" fixes long delay on single <esc> in conque - may effect others too
set timeoutlen=250

" nose compiler 
"autocmd BufNewFile,BufRead *.py compiler nose

" toggle tagbar
nnoremap <silent> <leader>t :TagbarToggle<CR>


" for puting virtualenv in status line
"%{virtualenv#statusline()}
