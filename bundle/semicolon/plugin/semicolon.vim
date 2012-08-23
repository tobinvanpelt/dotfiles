call semicolon#start()

" Key Commands

nnoremap <silent> ;; :SemicolonToggleConsole<cr>
nnoremap <silent> ;i :SemicolonIPython<cr>
nnoremap <silent> ;ii :SemicolonRestartIPython<cr>
           
nnoremap ;x :SemicolonClearBreakpoints<cr>
nnoremap ;b :SemicolonToggleBreakpointsList<cr>

nnoremap ;T :SemicolonRunAllTests<cr>
nnoremap ;R :call semicolon#run_prompt()<cr>


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
