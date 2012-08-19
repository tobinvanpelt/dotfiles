"if exists('g:semicolon_loaded')
"    finish
"endif

"let g:semicolon_loaded = 1


if !exists('g:running_tmux')
    let g:running_tmux = $TMUX != ''
    if g:running_tmux
        call system('tmux rename-window semicolon')
        call system('tmux setw -t semicolon remain-on-exit')

        silent !echo -en "\033]2;edit\\007"
        redraw!
    endif
endif


if !exists('g:semicolon_console')
   let g:semicolon_console = 'ipython --colors=linux'
endif

if !exists('g:semicolon_breakpoint')
    let g:semicolon_breakpoint = 'import ipdb; ipdb.set_trace()'
endif

if !exists('g:semicolon_tag')
   let g:semicolon_tag = '# XXX Breakpoint'
endif

if !exists('g:semicolon_autosave_on_toggle')
    let g:semicolon_autosave_on_toggle = 1
endif

                                         
" Key Commands

nnoremap <silent> ;c :SemicolonToggleConsole<cr>
nnoremap <silent> ;i :SemicolonIPython<cr>
nnoremap <silent> ;r :SemicolonRestartIPython<cr>
           
nnoremap ;x :SemicolonClearBreakpoints<cr>
nnoremap ;b :SemicolonToggleBreakpointsList<cr>
nnoremap ;T :SemicolonRunAllTests<cr>


" Commands
command! SemicolonToggleConsole call semicolon#toggle_console()
command! SemicolonIPython call semicolon#select_ipython()
command! SemicolonRestartIPython call semicolon#restart_ipython()


command! -nargs=* -complete=file SemicolonRun call semicolon#run(<f-args>)
command! -nargs=* -complete=file SemicolonDebugTest call semicolon#debug_test(<f-args>)
command! SemicolonRunAllTests call semicolon#run_all_tests()

command! SemicolonClearBreakpoints call semicolon#clear_breakpoints()
command! SemicolonToggleBreakpointsList call semicolon#toggle_breakpoints_list()

" used to track the quickfix window
augroup qfixtoggle
    autocmd!
    autocmd BufWinEnter quickfix call semicolon#set_qfix_win()
    autocmd BufWinLeave * call semicolon#unset_qfix_win()

    autocmd VimLeave * call semicolon#quit()
augroup end
