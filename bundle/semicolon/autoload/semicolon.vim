let s:base_dir = expand('<sfile>:h') . '/..'

" toggle a breakpoint within a .py file
func! semicolon#toggle_breakpoint()
    echo ''
    if match(getline('.'), g:semicolon_tag) == -1
        execute 'normal! O' . g:semicolon_breakpoint '  ' g:semicolon_tag
    else
        normal! dd
    endif

    if g:semicolon_autosave_on_toggle
        write
    endif

    call s:find_breakpoints()
endfunc

" toggle open closed the break points in the quick fix window
func! semicolon#toggle_breakpoints_list()
    if exists('g:semicolon_qfix_win')
        redraw
        echo ''
        cclose
    else
        call s:find_breakpoints()
        cwindow
    endif
endfunc

" set the current qfix window
func! semicolon#set_qfix_win()
    let g:semicolon_qfix_win = bufnr('$')
endfunc

" clears the current qfix window
func! semicolon#unset_qfix_win()
    if exists('g:semicolon_qfix_win') && expand('<abuf>') == g:semicolon_qfix_win
        unlet! g:semicolon_qfix_win
    endif
endfunc

" clear all of the breakpoints in extedned directory structure
func! semicolon#clear_breakpoints()
    if s:find_breakpoints() == 0
        return
    endif

    let tmp_buffs = []

    " get all of the buffers from the quickfix
    let buff_list = {}
    for buf in getqflist()
        let k = buf['bufnr']
        let b = bufname(k)
        let buff_list[k] = b
    endfor
        
    " remove the breakpoints
    copen
    execute 'silent arglocal' join(values(buff_list))
    execute 'silent argdo g/' . g:semicolon_tag . '/d | update'
    quit
endfunc

" start an ipython console
func! semicolon#console(...)
    call conque_term#open(g:semicolon_console, a:000)
endfunc

" run current file if no .py is given.  Add any additional conque arguments
func! semicolon#run(...)
    let res = call('s:parse', a:000)
    let fname = res[0]
    let args = res[1]

    " save the buffer and run it
    update
    call s:conque_cmd('python ' . fname, args)
endfunc

" prompt for arguments to run
func! semicolon#run_prompt()
    let fname = expand('%') 
    let args = input('args: ')

    update
    call s:conque_cmd('python ' . fname . ' ' . args, ['vsplit'])
endfunc

" debug the current test file if no arguments are given
func! semicolon#debug_test(...)
    let res = call('s:parse', a:000)
    let fname = res[0]
    let args = res[1]

    update
    call s:conque_cmd('nosetests ' . fname, args)
endfunc

" run the test given in the current file. if no args then run all tests in file
func! semicolon#run_test(...)
    let cmd = 'make!'
    let cmd .= expand('%')
    if a:0 > 0
        if len(a:1) > 0
            let cmd .= ':' . a:1
        endif
    endif
    execute cmd
endfunc

" run all tests
func! semicolon#run_all_tests()
    make! 
    cwindow
endfunc

" prompt for the name of a test in the current file to run
func! semicolon#run_test_prompt()
    let test = input('test name: ')
    call semicolon#run_test(test)
endfunc

func! s:find_breakpoints()
    execute 'noautocmd silent! vimgrep /' . g:semicolon_tag . '/j **/*.py' 

    let num = len(getqflist())
    if num == 0
        redraw
        echo 'No breakpoints.'
    endif

    return num
endfunc

func! s:parse(...)
    if a:0 > 0
        if match(a:1, '.py') != -1
            return [expand(a:1), a:000[1:]]
        endif
    endif

    if &filetype != 'python'
        echo 'Filetype must be .py'
        return
    endif

    return [expand('%:p'), a:000]
endfunc

func! s:conque_cmd(cmd, args)
    call conque_term#open(s:base_dir . '/pause ' . a:cmd, a:args)
endfunc
