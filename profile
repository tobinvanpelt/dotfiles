# ls_colors
alias ls="ls -G"
export LSCOLORS=gxfxcxdxbxegedabagacad

# start tmux with 256 colors
alias tmux="tmux -2"

# use vim editing in bash
set -o vi
EDITOR=vim
VISUAL=vim

# personal bin on path
PATH=/usr/local/bin:$PATH
PATH=/usr/local/share/python:$PATH
PATH=$HOME/bin:$PATH

# Setup for virtualenv and the wrapper
WORKON_HOME=$HOME/.virtualenvs
PROJECT_HOME=$HOME/i3dtech
source virtualenvwrapper.sh

# added for xcode compiling - THVP
ARCHFLAGS="-arch i386 -arch x86_64"

# used for jsctags
NODE_PATH=/usr/local/lib/jsctags/:$NODE_PATH
