nnoremap <buffer> ;r :SemicolonRun vsplit<cr>
nnoremap <buffer> ;rr :call semicolon#run_prompt()<cr>

nnoremap <buffer> ;d :SemicolonDebugTest vsplit<cr>
nnoremap <buffer> ;t :SemicolonRunTest<cr>
nnoremap <buffer> ;tt :call semicolon#run_test_prompt()<cr>

nnoremap <buffer> ;; :SemicolonToggleBreakpoint<cr>

command! SemicolonToggleBreakpoint call semicolon#toggle_breakpoint()
command! -nargs=* -complete=file SemicolonRunTest call semicolon#run_test(<f-args>)
