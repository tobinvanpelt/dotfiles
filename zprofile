# pick up all of the env setting in .profile
. ~/.profile

export VIRTUALENVWRAPPER_PYTHON_ORIGINAL=$(which python)

# start tmux with 256 colors
alias tmux="tmux -2"

# use vim editing in bash
set -o vi     
