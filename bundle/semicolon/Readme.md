Semicolon
=========

Semicolon is a pytyhon IDE for vim that relies on tmux. It incorporates a
python/ipython console, testing using nose, debugging, and debugging tests.

To utilize semicolon vim must be run within tmux as:

    $tmux new vim

The IDE consists of vim as an editor and provides a console that includes a
debugging console on the left and an general interactive python console on the
right.

NOTE: 

Compatible with virtualenv.

Go to console window in other tmux window.

Describe debug behavior.

C-a ; - go back

exit ipython respawns

convenient terminal pane

mark all files with license / copyright


Console:

Debugging:

Testing:


Dependencies
------------

Currently it has the following vim dependencies:
    - tmux

It has the following python dependencies.  Install using pip:
    - nose
    - ipython
    - ipdb


Key Commands
------------
Console:

- `;;`  toggles open/close the console split pane below vim
- `;i`  open console and select ipython
- `;ii` reset ipython and select it

(Note C-a ; is last pane)


Breakpoints:

- `;<space>` toggles a breakpoint on/off for the current line in a .py file
- `;b` toggles a window listing of all breakpoints in the quickfix buffer
- `;x` delete all breakpoints in the current project

Debugging:

- `;r`  runs the current .py file
- `;rr` prompts for arguments to run the current .py file
- `;R`  prompts for filename and argument to run 
- `;d`  debugs the current python test file (uses nosetests)

Testing:

- `;T`  runs all project tests
- `;t`  runs the curretn python test file
- `;tt` prompts for nosetests to run in current test


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

- `:SemicolonToggleConsole`


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
- highlight breakpoints in file
- travel to breakpoint when navigating up down in breakppoint window
- possibly split breakpoint windows for a preview
- put the name of the next line to be executed in the breakpoint list

- when running tests comment out all breakpoints
- when deleting a breakpoint - preserve the yank buffer

- debug just a specific test from the quickfix window
- expand the concept of a project

- configure with python/ipyton or pdb/ipdb
