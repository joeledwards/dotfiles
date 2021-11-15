# dotfiles

Portable profile for common Linux CLI utilities (bash, vim, git, etc.)

Files can be either copied or symlinked to their equivalent hidden file in your $HOME directory.

You can use `setup.sh` to perform this automatically. NOTE: the setup script will not forcibly overwrite anything, so you need to move existing resources (e.g. .bashrc) out of the way prior to running setup.


## Links

### bash
* $HOME/.bashrc <- bashrc
* $HOME/.server-login-aliases.bash <- server-login-aliases.bash

### git
* $HOME/.git-completion.bash <- git-completion.bash

### vim
* $HOME/.vimrc <- vimrc  # vim configuration
* $HOME/.vim <- vim  # vim plugins; I recommend using a plugin manager instead, I just haven't had any luck with setting one up myself


## .bashrc optional customizations

The following files may be added for managing bash-specific customizations. They will be sourced if they are found.

* `$HOME/.bash_aliases` - command aliases
* `$HOME/.bash_head` - processed _before_ body of .bashrc
* `$HOME/.bash_tail` - processed _after_ body of .bashrc

