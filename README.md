profile
======

Portable profile for common Linux CLI programs (bash, vim, git, etc.)

files must be either copied or symbolically linked to their equivalent hidden file in $HOME

bash
$HOME/.bashrc <- bashrc
$HOME/.server-login-aliases.bash <- server-login-aliases.bash
$HOME/.bash_aliases (aliases to be sourced if exists)
$HOME/.bash_head (items processed before body of bashrc if exists)
$HOME/.bash_tail (items processed after body of bashrc if exists)

git
$HOME/.git-completion.bash <- git-completion.bash

vim
$HOME/.vimrc <- vimrc (vim configuration)

