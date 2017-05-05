" Tobin's vimrc file 

" vundle init
set nocompatible
filetype off
set rtp+=~/.vim/Vundle.vim

call vundle#begin()
Plugin 'VundleVim/Vundle.vim'
Plugin 'scrooloose/nerdtree'
Plugin 'kien/ctrlp.vim'
Plugin 'Lokaltog/vim-powerline'
Plugin 'SirVer/ultisnips'
Plugin 'honza/vim-snippets'
Plugin 'scrooloose/syntastic'
Plugin 'davidhalter/jedi-vim'
Plugin 'mustache/vim-mustache-handlebars'
Plugin 'groenewege/vim-less'
Plugin 'pangloss/vim-javascript'
Plugin 'jelera/vim-javascript-syntax'
Plugin 'nathanaelkane/vim-indent-guides'
Plugin 'Valloric/YouCompleteMe'
Plugin 'suan/vim-instant-markdown'
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-surround'
Plugin 'Peeja/vim-cdo'
Plugin 'chase/vim-ansible-yaml'
Plugin 'lepture/vim-jinja'
Plugin 'IN3D/vim-raml'
call vundle#end()
filetype plugin indent on

" Colors
set t_Co=256
syntax on
set background=dark
colorscheme desert256

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
highlight Search ctermfg=None ctermbg=244

" map some leaders quick keys
nnoremap <silent> <leader>c :call SetCursorline()<CR>
nnoremap <silent> <leader>h :set hls! <CR>
nnoremap <silent> <leader>= :set paste! <CR>

" fix cursor keys when in insert
inoremap <Esc>A <up>
inoremap <Esc>B <down>
inoremap <Esc>C <right>
inoremap <Esc>D <left>

" cursorline
"highlight ColorColumn ctermbg=235 guibg=#2c2d27
highlight ColorColumn ctermfg=None ctermbg=239
highlight SignColumn ctermbg=None
highlight LineNr ctermfg=229 ctermbg=None
highlight CursorLineNr cterm=bold ctermbg=238 ctermfg=208
highlight CursorLine cterm=bold ctermbg=238 ctermfg=NONE

let &colorcolumn=join(range(101,999),",")
let g:cursorline = 1

autocmd WinEnter,BufEnter * call UpdateCursorLine()
autocmd WinLeave,BufLeave * setlocal nocursorline

autocmd InsertEnter * call CursorInsertHighlight()
autocmd InsertLeave * call CursorNormalHighlight()

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

func! CursorInsertHighlight()
    highlight CursorLine ctermbg=235
    highlight CursorLineNr ctermbg=235
endfunc

func! CursorNormalHighlight()
    highlight CursorLine ctermbg=238
    highlight CursorLineNr ctermbg=238
endfunc

" for copying to OSX clipboard
set clipboard=unnamed

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

" upon hitting escape to change modes,
" send successive move-left and move-right
" commands to immediately redraw the cursor
inoremap <special> <Esc> <Esc>hl


set hlsearch

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

set history=50		" keep 50 lines of command line history
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set incsearch		" do incremental searching

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
set textwidth=99

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

" HTML
autocmd FileType html setlocal sw=2
autocmd FileType html setlocal ts=2
autocmd FileType html setlocal sts=2
autocmd FileType html setlocal textwidth=0

" CSS
autocmd FileType css setlocal sw=2
autocmd FileType css setlocal ts=2
autocmd FileType css setlocal sts=2

" js tabs
autocmd FileType javascript setlocal sw=2
autocmd FileType javascript setlocal ts=2
autocmd FileType javascript setlocal sts=2

" folding
"set foldmethod=syntax
"set foldlevelstart=99
"let javascript_fold=1

set foldmethod=indent
set foldnestmax=10
set nofoldenable
set foldlevel=1
set foldignore=

" auto completes
autocmd FileType python set omnifunc=pythoncomplete#Complete
autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
autocmd FileType css set omnifunc=csscomplete#CompleteCSS

set hidden
set virtualedit=all
set wildmenu

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

call system('rm -f ~/.vim/tmp/backup/*~')
call system('rm -f ~/.vim/tmp/backup/.*~')

" -----------------------------------------------------------------------------

" quick vimrc access
command! Vimrc edit ~/.vimrc 

" remove ^M in dos files
command! FileToUnix %s///g

" clear search when refreshing
nnoremap <silent> <C-l> :nohl<CR><C-l>

" easytagsder
let g:easytags_dynamic_files = 2

" nerdtree
nmap <silent> <leader>p :NERDTreeToggle<CR>
nmap <silent> <leader>P :NERDTree<CR>
let NERDTreeIgnore = ['\.pyc$']

" *.ipy files
autocmd BufNewFile,BufRead *.ipy set filetype=python

" coffee-script
autocmd FileType coffee setlocal sw=2
autocmd FileType coffee setlocal ts=2
autocmd FileType coffee setlocal sts=2

let coffee_make_options = '--bare'
"au BufWritePost *.coffee silent CoffeeMake! -b | cwindow | redraw!
let coffee_compile_vert = 1

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
" cache last 10 files
let g:ctrlp_use_caching = 10
" clear cache on exit
let g:ctrlp_clear_cache_on_exit = 1

nnoremap <silent> <leader>f :CtrlP<CR>
nnoremap <silent> <leader>b :CtrlPBuffer<CR>
nnoremap <silent> <leader>m :CtrlPMRUFiles<CR>

" defualt split locations
set splitbelow
set splitright


" python mode
" turn off lint, breakpoint, and run
let g:pymode_lint=0
let g:pymode_breakpoint=0
let g:pymode_run=0


" --- tagbar ------------------------------------------------------------------
let g:tagbar_sort = 0
let g:tagbar_autoclose = 1

nnoremap <silent> <leader>t :TagbarToggle<CR>
                               
set nocompatible   " Disable vi-compatibility
set laststatus=2   " Always show the statusline
set encoding=utf-8 " Necessary to show unicode glyphs


" --- Syntastic ---------------------------------------------------------------
let g:syntastic_python_checkers=['flake8']
let g:syntastic_python_flake8_args='--ignore=E126,E127,E128,E701,E702'
let g:syntastic_python_flake8_args='--max-line-length=100'
let g:syntastic_python_python_exec = 'python3'

let g:syntastic_check_on_open=1 
let g:syntastic_loc_list_height=4
let g:syntastic_error_symbol='✗'
let g:syntastic_warning_symbol='⚠'

nmap <silent> <leader>E :SyntasticToggleMode<CR>
nmap <silent> <leader>e :SyntasticCheck<CR>


" --- Jedi --------------------------------------------------------------------
let g:jedi#use_tabs_not_buffers = 0
let g:jedi#popup_on_dot = 0
autocmd FileType python setlocal completeopt-=preview


" --- Supertab ----------------------------------------------------------------
"let g:SuperTabDefaultCompletionType = "context"
""let g:SuperTabContextDefaultCompletionType="<c-x><c-k>"
"let g:SuperTabLongestEnhanced = 1
"let g:SuperTabLongestHighlight = 1
"let g:SuperTabClosePreviewOnPopupClose = 1


" --- Ultisnips ---------------------------------------------------------------
let g:UltiSnipsSnippetDirectories = ["UltiSnips", "MySnips"]
let g:UltiSnipsExpandTrigger="<c-l>"
let g:UltiSnipsJumpForwardTrigger="<c-n>"
let g:UltiSnipsJumpBackwardTrigger="<c-b>"


" --- delimitMate -------------------------------------------------------------
imap <C-c> <CR><Esc>O


" --- YouCompleteMe -----------------------------------------------------------
let g:ycm_add_preview_to_completeopt=0
let g:ycm_confirm_extra_conf=0
set completeopt-=preview


" --- vim-instant-markdown ----------------------------------------------------
let g:instant_markdown_slow = 1


" pydoc.vim
let g:pydoc_cmd = 'python -m pydoc'
let g:pydoc_open_cmd = 'vsplit'
let g:pydoc_highlight = 0 



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
