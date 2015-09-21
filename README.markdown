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
    brew install zsh
    ```

4. Change to zsh:

    ```
    sudo chsh -s /bin/zsh
    ```

5. Create symlinks by editing and run the `init_osx` or `init_debian` script.

6. Install vundle:

    ```
    git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
    vim +BundleInstall +qall
    ```

## External Dependencies

### YouCompleteMe

Be sure that vim is built with python.

debian:

    sudo apt-get install build-essential cmake
    sudo apt-get install python2.7-dev

osx:

    brew install cmake

then:

    cd ~/.vim/bundle/YouCompleteMe
    git submodule update --init --recursive
    ./install.sh


### Instant Markdown

    sudo npm -g install instant-markdown-d
