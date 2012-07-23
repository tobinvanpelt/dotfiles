let g:semicolon_breakpoint = 'import ipdb; ipdb.set_trace()'
let g:semicolon_tag = '# XXX Breakpoint'

nnoremap <buffer> ;; :call ToggleBreakpoint()<cr>
nnoremap ;o :call OpenBreakpointsList()<cr>
nnoremap ;c :call CloseBreakpointsList()<cr>
nnoremap ;x :call RemoveAllBreakpoints()<cr>

func! ToggleBreakpoint()
    if match(getline('.'), g:semicolon_tag) == -1
        execute 'normal! O' . g:semicolon_breakpoint '  ' g:semicolon_tag
    else
        normal! dd
    endif
endfunc

func! FindBreakpoints()
    execute 'noautocmd silent! vimgrep /' . g:semicolon_tag . '/j **/*.py' 

    let num = len(getqflist())
    if num == 0
        redraw
        echo 'No breakpoints.'
    endif

    return num
endfunc

func! OpenBreakpointsList()
    call FindBreakpoints()
    cwindow
endfunc

func! CloseBreakpointsList()
    cclose
endfunc

func! RemoveAllBreakpoints()
    if FindBreakpoints() == 0
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
