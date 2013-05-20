# pick up all of the env setting in .profile
. ~/.profile

export VIRTUALENVWRAPPER_PYTHON_ORIGINAL=$(which python)

# start terminal vim with server
alias svim="vim --servername VIM"

# start tmux with 256 colors
alias tmux="tmux -2"

# veewee for vagrant alias
alias veewee='bundle exec veewee'

# sup for supervisorctl alias
alias sup='supervisorctl'

# use vim editing in bash
set -o vi     
