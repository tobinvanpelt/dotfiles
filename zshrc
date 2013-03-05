# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
#ZSH_THEME="robbyrussell"

# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Comment this out to disable weekly auto-update checks
# DISABLE_AUTO_UPDATE="true"

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
COMPLETION_WAITING_DOTS="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(brew git pip python vi-mode)

source $ZSH/oh-my-zsh.sh


# -----------------------------------------------------------------------------
# THVP

# helper for prompt
function virtualenv_info {
    [ $VIRTUAL_ENV ] && echo '['`basename $VIRTUAL_ENV`']'
}

PROMPT='%{$fg[blue]%}%m:%{$fg[cyan]%}%~ %{$fg[red]%}%n➜ %{$reset_color%}'
RPROMPT='$(vi_mode_prompt_info) %{$fg[green]%}$(virtualenv_info) $(git_prompt_info)%{$reset_color%}%'
VIRTUAL_ENV_DISABLE_PROMPT=1

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[yellow]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_colors%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[red]%} ✗"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[green]%} ✓"


# set this back to the original so that zsh uses the base python to run
# virtualenv.  This is originally set in .zprofile
export VIRTUALENVWRAPPER_PYTHON=$VIRTUALENVWRAPPER_PYTHON_ORIGINAL

#soruce virtualenv
source virtualenvwrapper.sh 2> /dev/null

# initializes the semicolon command
. ~/.vim/bundle/vim-semicolon/scripts/semicolon_init

# automatically start virtualenv if VIRTUAL_ENV is set
# (used with tmux to inherit the current virtualenv)
if [ -n "$VIRTUAL_ENV" ]; then
    workon $(basename $VIRTUAL_ENV)
fi
