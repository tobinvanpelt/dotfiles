" Todo: cahnge all g: to s: ?

let s:base_dir = expand('<sfile>:h') . '/../scripts/'
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
        call semicolon#open_console()
    else
        " possibly mannually closed if they are both invalid
        if !s:is_pane_valid(g:semicolon_debug_pane_id) &&
                    \ !s:is_pane_valid(g:semicolon_ipython_pane_id)
            let g:semicolon_console_visible = 0
            call semicolon#open_console()
        else
            call semicolon#close_console()
        endif
    endif
endfunc


func! semicolon#open_console()
    if !s:check_tmux()
        return
    endif

    if g:semicolon_console_visible
        return
    endif

    call s:init_console()

    call system('tmux join-pane -l 20 -d -s ' . g:semicolon_debug_pane_id)
    call system('tmux join-pane -h -d' .
                \ ' -t ' . g:semicolon_debug_pane_id .
                \ ' -s ' . g:semicolon_ipython_pane_id)

    let g:semicolon_console_visible = 1
endfunc


func! semicolon#close_console()
    if !s:check_tmux()
        return
    endif

    if !g:semicolon_console_visible
        return
    endif

    call s:check_console()

    call system('tmux join-pane -d -p 80' .
                \ ' -s ' . g:semicolon_debug_pane_id .
                \ ' -t ' . g:semicolon_terminal_pane_id)

    call system('tmux join-pane -h -d ' .
                \ ' -s ' . g:semicolon_ipython_pane_id .
                \ ' -t ' . g:semicolon_debug_pane_id)

    let g:semicolon_console_visible = 0
endfunc


func! semicolon#select_ipython()
    if !s:check_tmux()
        return
    endif

    call semicolon#open_console()
    call system('tmux select-pane -t ' . g:semicolon_ipython_pane_id)
endfunc


func! semicolon#restart_ipython()
    if !s:check_tmux()
        return
    endif

    call s:respawn_ipython()
    call semicolon#select_ipython()
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
func! semicolon#run_args_prompt()
    let fname = expand('%') 
    let args = input('python ' . fname . ' ', '', 'file')
    call call('semicolon#run', insert(split(args, '\ '), fname))
endfunc


" prompt for filename and arguments to run
func! semicolon#run_prompt()
    let args = input('python ', '', 'file')
    call call('semicolon#run', split(args, '\ '))
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
    let test = input('test name: ', '', 'file')
    call semicolon#run_test(test)
endfunc


func! semicolon#start()
    if !exists('g:semicolon_breakpoint')
        let g:semicolon_breakpoint = 'import ipdb; ipdb.set_trace()'
    endif

    if !exists('g:semicolon_tag')
       let g:semicolon_tag = '# XXX Breakpoint'
    endif

    if !exists('g:semicolon_autosave_on_toggle')
        let g:semicolon_autosave_on_toggle = 1
    endif

    let g:semicolon_running_tmux = $TMUX != ''

    if g:semicolon_running_tmux
        call system('tmux rename-window semicolon')
        call system('tmux setw -u -t semicolon visual-activity')
        call system('tmux setw -t semicolon remain-on-exit')

        silent !echo -en "\033]2;edit\\007"
        redraw!
    endif    

    " TODO: Check for .git as default too ?
    " if there is no project then just use the current directory
    if $VIRTUAL_ENV != ''
        if $VIRTUALENVWRAPPER_PROJECT_FILENAME != ''
            let fname = $VIRTUAL_ENV .
                        \ '/' . $VIRTUALENVWRAPPER_PROJECT_FILENAME
            let g:semicolon_project_dir = system('cat ' . fname)[0:-2]
        endif
    endif
endfunc


func! semicolon#quit()
    if exists('g:semicolon_terminal_pane_id') &&
                \ s:is_pane_valid(g:semicolon_ipython_pane_id)
        call system('tmux kill-pane -t ' . g:semicolon_terminal_pane_id)
    endif

    if exists('g:semicolon_debug_pane_id') &&
                \ s:is_pane_valid(g:semicolon_debug_pane_id)
        call system('tmux kill-pane -t ' . g:semicolon_debug_pane_id)
    endif

    if exists('g:semicolon_ipython_pane_id') &&
                \ s:is_pane_valid(g:semicolon_ipython_pane_id)
        call system('tmux kill-pane -t ' . g:semicolon_ipython_pane_id)
    endif

    call system('tmux setw -u -t semicolon remain-on-exit')
    call system('tmux kill-window -t console')

    let shell_name = split($SHELL, '/')[-1]
    call system('tmux rename-window ' . shell_name)
    silent !echo -en "\033]2;$HOSTNAME\\007"
endfunc


"------------------------------------------------------------------------------

func! s:check_tmux()
    if !g:semicolon_running_tmux
        echo "Semicolon must be run within a tmux session.
            \ (Use 'tmux new vim' to start one.)"
    endif

    return g:semicolon_running_tmux
endfunc


func! s:init_console()
    call s:check_console()
    call s:check_debug()
    call s:check_ipython()
endfunc


func! s:check_console()
    let res = system('tmux list-windows')
    if match(res, 'console') == -1
        call s:make_console()
        return
    endif
    
    if exists('g:semicolon_terminal_pane_id') &&
                \ !s:is_pane_valid(g:semicolon_terminal_pane_id)
        call s:make_debug()
    endif
endfunc


func! s:check_debug()
    if exists('g:semicolon_debug_pane_id') &&
                \ s:is_pane_valid(g:semicolon_debug_pane_id)
        return
    endif

    call s:make_debug()
endfunc


func! s:check_ipython()
    if exists('g:semicolon_ipython_pane_id') &&
                \ s:is_pane_valid(g:semicolon_ipython_pane_id)
        return
    endif

    call s:make_ipython()
endfunc


func! s:make_console()
    let res = system('tmux list-windows')
    if match(res, 'console') == -1
        call system('tmux new-window -d -n console')
        call system('tmux setw -t console remain-on-exit')
        call system('tmux setw -u -t console monitor-activity')

        call s:stamp_pane('console', 'terminal')
        call s:set_virtualenv()
        call s:clear_pane('console')
        let g:semicolon_terminal_pane_id = s:get_last_pane_id('console')
    endif
endfunc


func! s:make_debug()
    call system('tmux split-window -d -t ' .
                \ g:semicolon_terminal_pane_id . ' -p 80')
    let g:semicolon_debug_pane_id = s:get_last_pane_id('console')

    call s:respawn_debug()
endfunc


func! s:make_ipython()
    call system('tmux split-window -h -d -t ' . g:semicolon_debug_pane_id)
    let g:semicolon_ipython_pane_id = s:get_last_pane_id('console')

    call s:respawn_ipython()
endfunc


func! s:respawn_debug(...)
    call s:init_console()

    call system('tmux clear-history -t' . g:semicolon_debug_pane_id)
        
    if a:0 == 0
        let full_cmd = s:base_dir . 'spawn_debug -x'
        call system('tmux respawn-pane -k -t ' . g:semicolon_debug_pane_id
                \ . ' "' . full_cmd . '"')

        return
    else
        let cmd = a:1
    endif

    let full_cmd = s:base_dir . 'spawn_debug'
    
    if $VIRTUAL_ENV != ''
        let full_cmd .= ' -v ' . $VIRTUAL_ENV
    endif

    if g:semicolon_console_visible
        echo 'XXX'
        let full_cmd .= ' ' . '-o'
    endif

    let full_cmd .= ' ' . $TMUX_PANE . ' ' . cmd 

    call system('tmux respawn-pane -k -t ' . g:semicolon_debug_pane_id
                \ . ' "' . full_cmd . '"')
endfunc


func! s:respawn_ipython()
    if $VIRTUAL_ENV != ''
        let full_cmd = s:base_dir . 'spawn_ipython -v ' . $VIRTUAL_ENV .
                    \ ' ' . $TMUX_PANE
    else
        let full_cmd = s:base_dir . 'spawn_ipython ' . $TMUX_PANE 
    endif

    call system('tmux respawn-pane -k -t ' . g:semicolon_ipython_pane_id
                \ . ' "' . full_cmd . '"')
endfunc


func! s:is_pane_valid(pane)
    return match(system('tmux list-panes -a'), a:pane) != -1
endfunc


func! s:get_last_window_id()
    let res = system('tmux list-windows -F "#{window_index}"')
    return split(res)[-1]
endfunc


func! s:get_last_pane_id(window)
    let res = system('tmux list-panes -t ' . a:window . ' -F "#{pane_id}"')
    
    let vals = split(res)
    return sort(vals)[-1]
endfunc


func! s:send_keys(pane, cmd)
    call system('tmux send-keys -t ' . a:pane . ' "' . a:cmd . '" C-m')
endfunc


func! s:send_debug_cmd(cmd)
    call s:respawn_debug(a:cmd)
    call semicolon#open_console()
    call s:select_debug()
endfunc


func! s:stamp_pane(pane, name)
    let cmd = "echo -en '\\033]2;" . a:name . "\\033\\'"
    call s:send_keys(a:pane, cmd)
endfunc


func! s:set_virtualenv()
    call system('source ' . $VIRTUAL_ENV . '/bin/activate' )
endfunc


func! s:clear_pane(pane)
    call s:send_keys(a:pane, 'clear')
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
    if exists('g:semicolon_project_dir')
        let tdir = g:semicolon_project_dir . '/**/*.py'
    else
        let tdir = '*.py'
    end

    execute 'noautocmd silent! vimgrep /' . g:semicolon_tag . '/j ' . tdir

    let num = len(getqflist())
    if num == 0
        redraw
        echo tdir
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
