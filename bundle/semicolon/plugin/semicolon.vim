"if exists('g:semicolon_loaded')
"    finish
"endif

"let g:semicolon_loaded = 1


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

"nnoremap ;c :SemicolonConsole<cr>
nnoremap <silent> ;c :SemicolonToggleConsole<cr>
           
nnoremap ;x :SemicolonClearBreakpoints<cr>
nnoremap ;b :SemicolonToggleBreakpointsList<cr>
nnoremap ;T :SemicolonRunAllTests<cr>


" Commands
"command! -nargs=* SemicolonConsole call semicolon#console(<f-args>)
command! -nargs=* SemicolonToggleConsole call semicolon#toggle_console()
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
augroup end
