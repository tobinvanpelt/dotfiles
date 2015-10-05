# Dotfiles

## Installation

1. Install git:
    
    ```
    git clone git@github.com:tobinvanpelt/dotfiles.git ~/.dot
    cd ~/.dot
    git submodule update --init --recursive
    ```

2. Install zsh (on Deian):

    ```
    sudo apt-get update
    sudo apt-get install zsh
    ```

3. Install zsh (on osx):

    ```
    brew update
    brew install zsh
    ```

4. Change to zsh:

    ```
    chsh -s /bin/zsh
    ```

5. Create symlinks by editing and run the `init_osx` or `init_debian` script.


6. Install vundle:

    ```
    git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
    vim +BundleInstall +qall
    ```

7. Be sure that vim is built with python. For debian: 

    ```sudo apt-get install vim-nox```


8. Be sure you have build tools (on Debian)

    ```
    sudo apt-get install build-essential cmake
    sudo apt-get install python2.7-dev
    ```

9. Be sure you have build tools (on OSX)

    ```brew install cmake```

10. Install YouCompleteMe:

    ```
    cd ~/.vim/bundle/YouCompleteMe
    git submodule update --init --recursive
    ./install.sh
    ```


### Instant Markdown

    sudo npm -g install instant-markdown-d
