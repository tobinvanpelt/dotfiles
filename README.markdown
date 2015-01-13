Installation Notes
==================
1. git clone git@github.com:tobinvanpelt/dotfiles.git ~/.dot

2. cd ~/.dot

3. git submodule update --init

4. apt-get install zsh

5. chsh -s /bin/zsh


Create Symlinks
---------------
Edit and run the init_osx or init_debian script.


Update Submodules
-----------------
Updating a specific submodule (example):

    cd ~/.dot/vim/bundle/fugitive
    git pull origin master

Updating all submodules:

    git submodule foreach git pull origin master


Common Additional Steps
-----------------------
1. pip install ipython

2. pip install ipdb

3. pip install rednose

4. edit .profile as needed:

export PYTHONPATH=<python dirs>


External Dependencies
---------------------

###YouCompleteMe
1. `sudo apt-get install build-essential cmake`
2. `cd ~/.vim/bundle/YouCompleteMe`
3. `git submodule update --init --recursive`
