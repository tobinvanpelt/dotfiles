Installation Notes
==================

    git clone git@github.com:tobinvanpelt/dotfiles.git ~/.dot
    cd ~/.dot
    git submodule update --init
    apt-get install zsh 
    chsh -s /bin/zsh


Create Symlinks
---------------
Edit and run the `init_osx` or `init_debian` script.


Update Submodules
-----------------

    git submodule update

Upgrade Submodules
------------------

Upgrading a specific submodule (example):

    cd ~/.dot/vim/bundle/fugitive
    git pull origin master

Upgrading all submodules:

    git submodule foreach git pull origin master

NOTE: This could create incompatibilities depending on version requirements.


Common Additional Steps
-----------------------

pip install ipython
pip install ipdb
pip install rednose

edit `.profile` as needed:

export PYTHONPATH=<python dirs>


External Dependencies
---------------------

### YouCompleteMe

    sudo apt-get install build-essential cmake
    cd ~/.vim/bundle/YouCompleteMe
    git submodule update --init --recursive

### Instant Markdown

    sudo npm -g install instant-markdown-d
