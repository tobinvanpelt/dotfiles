# Dotfiles

## Installation

1. Install git:
    
    ```
    git clone git@github.com:tobinvanpelt/dotfiles.git ~/.dot
    cd ~/.dot
    git submodule update --init --recursive
    ```

2. Install zsh:

    ```
    apt-get install zsh (on debian)
    brew install zsh (on osx)
    chsh -s /bin/zsh
    ```

3. Create Symlinks:

    Edit and run the `init_osx` or `init_debian` script.


5. Upgrade Submodules:

    From vim run `:PluginsUpdate`


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
