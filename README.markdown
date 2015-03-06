# Dotfiles Setup

## Install

    git clone git@github.com:tobinvanpelt/dotfiles.git ~/.dot
    cd ~/.dot
    git submodule update --init

debian:

    apt-get install zsh 

osx: 

    brew install zsh

then:

    chsh -s /bin/zsh


## Create Symlinks

Edit and run the `init_osx` or `init_debian` script.


## Update Submodules

    git submodule update --init --recursive

## Upgrade Submodules

Upgrading a specific submodule (example):

    cd ~/.dot/vim/bundle/fugitive
    git pull origin master

Upgrading all submodules:

    git submodule foreach git pull origin master

NOTE: This could create incompatibilities depending on version requirements.


## Common Additional Steps

Install reattach-to-user-namesapce with 

    brew install reattach-to-user-namespace


Install common python libraries

    pip install ipython
    pip install ipdb
    pip install nose2
    pip install rednose
    pip install virtualenv
    pip install virtualenvwrapper

edit `.profile` as needed:

    export PYTHONPATH=(python dir)


## External Dependencies

### YouCompleteMe

Be sure that macvim is compiled with the most recent python that is installed.
That is, you must brew python before brewing macvim.

debian:

    sudo apt-get install build-essential cmake

osx:

    brew install cmake

then:

    cd ~/.vim/bundle/YouCompleteMe
    git submodule update --init --recursive
    ./install.sh


### Instant Markdown

    sudo npm -g install instant-markdown-d
