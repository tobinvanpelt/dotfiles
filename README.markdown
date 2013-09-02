Installation Notes
==================

1. git clone git@github.com:tobinvanpelt/dotfiles.git ~/.dot
2. cd ~/.dot
3. git submodule init
4. git submodule update


Create Symlinks
---------------

Edit and run the init_links script.

NOTE: link to the appropriate distribution, e.g. profile.osx)


Update Submodules
-----------------

Updating a specific submodule (example):

    cd ~/.dot/vim/bundle/fugitive
    git pull origin master

Updating all submodules:

    git submodule foreach git pull origin master
