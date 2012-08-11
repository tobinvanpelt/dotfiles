Semicolon
=========

Semicolon is a pytyhon IDE for vim. It incorporates a python console, testing
using nose, debugging, and debugging tests.

It colorizes where needed and relies on ipython for the console, nose for
testing, and ipdb for debugging.

              
Dependencies
------------

Currently it has the following vim dependencies:

- Conque Shell: git://github.com/rson/vim-conque.git

It has the following python dependencies.  Install with pip:

- nose
- ipython
- ipdb

Key Commands
------------

Breakpoints Management:

- `;;` toggles a breakpoint on/off for the current line in a .py file
- `;b` toggles a list of all breakpoints in the quickfix buffer
- `;x` delete all breakpoints in the current project

Running and Debugging:

- `;c`  opens an ipython console with a vertical split
- `;r`  runs the current .py file
- `;rr` prompts for arguments and runs the current .py file
- `;d`  debugs the current python test file (uses nosetests)
- `;T`  runs all project tests
- `;t`  runs the curretn python test file
- `;tt` prompts for a python test to run from the current file


Additional useful quickfix commands:

- `:cwindow` opens the quickfix window
- `:cclose` closes the quickfix window
- `:cnext` goto the next breakpoint
- `:cprevious` goto to the previous breakpoint
- `:cc` goto the current breakpoint
- `:cr` goto the begining of the list

    
Commands
--------
- `:SemicolonToggleBreakpoint` (at current line)
- `:SemicolonClearBreakpoints` (within current project scope)
- `:SemicolonToggleBreakpointsList` (for current project scope)

- `:SemicolonRunAllTests` (within current project scope)
- `:SemicolonRunTest` <test> (run current test file or <test> within current) 

- `:SemicolonRun` <arguments> (pass in <arguments> to current file)
- `:SemicolonRunFile` <file> <arguments> (run any python file)
- `:SemicolonDebugTest` (run the current test file)

- `:SemicolonConsole`

Configuration
-------------

To redefine the breakpoint command use the following in your .vimrc:

    let g:semicolon_breakpoint=<new breakpoint line>

The default is:

    import ipdb; ipdb.set_trace()

The project scope is defined as the current directory and all sub directories.

Todos and Future Functionality
------------------------------

- change name of breakpoint buffer
- when leaving ConqueShell - the cursor line does not get highlighted
- highlight breakpoints in file
- travel to breakpoint when navigating up down in breakppoint window
- possibly split breakpoint windows for preview purposes
- put the name of the next line to be executed in the breakpoint list

- when running tests comment out all breakpoints
- when deleting a breakpoint - preserve the yank buffer
- color pass, fail, and error results while nosetest runs
- debug just a specific test from the quickfix window
- expand the project to be where a .semicolon folder is residing 

