let s:base_dir = expand('<sfile>:h') . '/..'
let g:semicolon_console_visible = 0


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
    if exists('g:semicolon_qfix_win') && expand('<abuf>')
                \ == g:semicolon_qfix_win
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


"------------------------------------------------------------------------------

" toggles the console on/off by moving panes to windows.  Note this
" functionality should be accomplished with link-pane but no such command yet
" exists with tmux
func! semicolon#toggle_console()
    if !s:check_tmux()
        return
    endif

    if !g:semicolon_console_visible
        call s:open_console()
    else
        " possibly mannually closed if they are both invalid
        if !s:is_pane_valid(g:semicolon_debug_pane_id) &&
                    \ !s:is_pane_valid(g:semicolon_ipython_pane_id)
            call s:open_console()
        else
            call s:close_console()
        endif
    endif
endfunc


"------------------------------------------------------------------------------

" run current file if no .py is given.  Add any additional conque arguments
func! semicolon#run(...)
    let res = call('s:parse', a:000)
    if len(res) == 0
        return
    endif

    let fname = res[0]
    let args = res[1]

    " save the buffer and run it
    update
    let cmd = 'python ' . fname . ' ' . join(args, ' ') 
    call s:send_debug_cmd(cmd)
endfunc


" prompt for arguments to run
func! semicolon#run_prompt()
    let fname = expand('%') 
    let args = input('args: ')

    call call('semicolon#run', insert(split(args, '\ '), fname))
endfunc


" debug the current test file if no arguments are given
func! semicolon#debug_test(...)
    let res = call('s:parse', a:000)
    let fname = res[0]
    let args = res[1]

    update
    let cmd = 'nosetests ' . fname . ' ' . join(args, ' ') 
    call s:send_debug_cmd(cmd)
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


"------------------------------------------------------------------------------

" be sure running inside tmux
func! s:check_tmux()
    let running = $TMUX != ''
    if !running
        echo "Semicolon must be run within a tmux session.
            \ (Use 'tmux new vim' to start one.)"
    end

    return running
endfunc


" opens the console
func! s:open_console()
    if g:semicolon_console_visible
        return
    endif

    call s:check_console()

    call system('tmux join-pane -l 20 -d -s ' . g:semicolon_debug_pane_id)
    call system('tmux join-pane -h -d -t ' . g:semicolon_debug_pane_id .
                \ ' -s ' . g:semicolon_ipython_pane_id)


    let g:semicolon_console_visible = 1
endfunc


" closes the console
func! s:close_console()
    if !g:semicolon_console_visible
        return
    endif

    let res = system('tmux list-windows')
    if match(res, 'console') == -1
        if s:is_pane_valid(g:semicolon_debug_pane_id)
            call system('tmux break-pane -d ' . '-t ' .
                        \ g:semicolon_debug_pane_id)

            let new_win = s:get_last_window_id()
            call system('tmux rename-window -t ' . new_win . ' console')
        else
            call s:make_debug()
        endif
    else
        call system('tmux join-pane -d ' .
                \ ' -s ' . g:semicolon_debug_pane_id . ' -t console')
    endif

    if s:is_pane_valid(g:semicolon_ipython_pane_id)
        call system('tmux join-pane -h -d ' .
                    \ ' -s ' . g:semicolon_ipython_pane_id .
                    \ ' -t ' . g:semicolon_debug_pane_id)
    else
        call s:make_ipython()
    endif

    let g:semicolon_console_visible = 0
endfunc


" if needed - builds the tmux windows for the console
func! s:check_console()
    if exists('g:semicolon_debug_pane_id')
        if !s:is_pane_valid(g:semicolon_debug_pane_id)
            call s:make_debug()
        endif
    else
        call s:make_debug()
    endif

    if exists('g:semicolon_ipython_pane_id')
        if !s:is_pane_valid(g:semicolon_ipython_pane_id)
            call s:make_ipython()
        endif
    else
        call s:make_ipython()
    endif
endfunc


func! s:make_debug()
    let res = system('tmux list-windows')
    if match(res, 'console') == -1
        call system('tmux new-window -d -n console')
    else
        call system('tmux split-window -d -t console')
    endif

    let g:semicolon_debug_pane_id = s:get_last_pane_id('console')

    if $VIRTUAL_ENV != ''
        call s:send_cmd(g:semicolon_debug_pane_id, 'source ' .
                    \ $VIRTUAL_ENV . '/bin/activate')
        call s:clear_pane(g:semicolon_debug_pane_id)
    endif
endfunc


func! s:make_ipython()
    call system('tmux split-window -d -t ' . g:semicolon_debug_pane_id .
            \ ' ipython')

    let g:semicolon_ipython_pane_id = s:get_last_pane_id('console')
endfunc


" check for pane validity
func! s:is_pane_valid(pane)
    return match(system('tmux list-panes -a'), a:pane) != -1
endfunc


" get the last window id
func! s:get_last_window_id()
    let res = system('tmux list-windows -F "#{window_index}"')
    return split(res)[-1]
endfunc


" get the last pane id of a window
func! s:get_last_pane_id(window)
    let res = system('tmux list-panes -t ' . a:window . ' -F "#{pane_id}"')
    return split(res)[-1]
endfunc


func! s:send_cmd(pane, cmd)
    call system('tmux send-keys -t ' . a:pane . ' "' . a:cmd . '" C-m')
endfunc


func! s:send_debug_cmd(cmd)
    call s:open_console()
    call s:select_debug()

    call s:send_cmd(g:semicolon_debug_pane_id, a:cmd)
endfunc


func! s:clear_pane(pane)
    call s:send_cmd(a:pane, 'clear')
    " wait for clear command to have completed before clearing
    call system('(sleep 1;tmux clear-history -t ' . a:pane . ') &')
endfunc


func! s:select_debug()
    call system('tmux select-pane -t ' . g:semicolon_debug_pane_id)
endfunc


func! s:select_ipython()
    call system('tmux select-pane -t ' . g:semicolon_ipython_pane_id)
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
        return []
    endif

    return [expand('%:p'), a:000]
endfunc


" Code for using Conque Shell

"func! s:conque_cmd(cmd, args)
"    call conque_term#open(s:base_dir . '/pause ' . a:cmd, a:args)
"endfunc


" start an ipython console
"func! semicolon#console(...)
"    call conque_term#open(g:semicolon_console, a:000)
"endfunc


"func! semicolon#run(...)
"    let res = call('s:parse', a:000)
"    let fname = res[0]
"    let args = res[1]
"
"    " save the buffer and run it
"    update
"
"    cmd = 'python ' . fname
"    call s:send_cmd(g:semicolon_debug_pane_id, cmd)
"    "call s:conque_cmd('python ' . fname, args)
"endfunc


"func! s:parse(...)
"    if a:0 > 0
"        if match(a:1, '.py') != -1
"            return [expand(a:1), a:000[1:]]
"        endif
"    endif
"
"    if &filetype != 'python'
"        echo 'Filetype must be .py'
"        return
"    endif
"
"    return [expand('%:p'), a:000]
"endfunc
