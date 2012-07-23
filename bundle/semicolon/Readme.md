Semicolon
---------

Semicolon is a project wide breakpoint manager for python.
              
The project is defined as the current directory and all sub directories.

- `;;` toggles a breakpoint on/off for the current line
- `;o` opens a list of all breakpoints in the quickfix buffer
- `;c` closes the breakpoint list (same as :cclose)
- `;x` delete all breakpoints in the current project

To redine the breakpoint command use the following in your .vimrc:

    let g:semicolon_breakpoint=<new breakpoint line>

The default is:

    import ipdb; ipdb.set_trace()

Note that the breakpoint list is a quickfix window.  Use `:cnext` to go to the next breakpoint or use <Enter> over the list item.
