# pick up all of the env setting in .profile
. ~/.profile

#unset VIRTUAL_ENV

# automatically start virtualenv if VIRTUAL_ENV is set
# (used with tmux to inherit the current virtualenv)
if [ -n "$VIRTUAL_ENV" ]; then
    . "$VIRTUAL_ENV/bin/activate"
fi

. ~/.vim/bundle/vim-semicolon/scripts/semicolon_init

# start tmux with 256 colors
alias tmux="tmux -2"

# use vim editing in bash
set -o vi     
