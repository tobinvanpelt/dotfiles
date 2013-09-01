Installation Notes
------------------

    git clone git@github.com:tobinvanpelt/dotfiles.git ~/.dot

Create symlinks:

    ln -s ~/.dot/profile ~/.profile
    ln -s ~/.dot/zprofile ~/.zprofile
    ln -s ~/.dot/zshrc ~/.zshrc
    ln -s ~/.dot/oh-my-zsh ~/.oh-my-zsh
    
    ln -s ~/.dot/vim ~/.vim
    ln -s ~/.dot/vimrc ~/.vimrc
    ln -s ~/.dot/gvimrc ~/.gvimrc

    ln -s ~/.dot/tmux.conf ~/.tmux.conf

    ln -s ~/.dot/gitconfig ~/.gitconfig
    ln -s ~/.dot/gitignore ~/.gitignore

    ln -s ~/.dot/config/flake8 ~/.config/flake8
    ln -s ~/.dot/ipython_config.py ~/.ipython/profile_default/ipython_config.py

(NOTE: link to the appropriate distribution, e.g. profile.osx)

Switch to the `~/.dot` directory, and fetch submodules:

    cd ~/.dot
    git submodule init
    git submodule update

Updating a specific submodule (example):

    cd ~/.dot/vim/bundle/fugitive
    git pull origin master

Updating all submodules:

    git submodule foreach git pull origin master
