#!/bin/bash

BASHRC=$HOME/.bashrc
VIMRC=$HOME/.vimrc
IDEAVIMRC=$HOME/.ideavimrc
CFG_DIR=$HOME/.config
VIM_DIR=$HOME/.vim
NVIM_DIR=$CFG_DIR/nvim
NVIM_CFG=$NVIM_DIR/init.vim
VRAPPERRC=$HOME/.vrapperrc
TMUXCONF=$HOME/.tmux.conf
GITCOMPLETION=$HOME/.git-completion.bash

BUNDLE_DIR=$HOME/.vim/bundle
VUNDLE_DIR=$BUNDLE_DIR/Vundle.vim

HOME_RBIN=$HOME/rbin
HOME_BIN=$HOME/bin

READLINK=$(which greadlink || which readlink)

# Link .bashrc
if [[ -e $BASHRC ]]; then
	echo "${BASHRC} exists, skipping"
else
	echo "linking ${BASHRC}"
	ln -s $($READLINK -f bashrc) $BASHRC
fi

# Create .vim config directory
if [[ ! -e $VIM_DIR ]]; then
	echo "creating directory ${VIM_DIR}"
  mkdir -p $VIM_DIR
fi

# Link .vimrc
if [[ -e $VIMRC ]]; then
	echo "${VIMRC} exists, skipping"
else
	echo "linking ${VIMRC}"
	ln -s $($READLINK -f vimrc) $VIMRC
fi

# Ensure config directory exists
if [[ ! -e $CFG_DIR ]]; then
	echo "creating directory ${CFG_DIR}"
  mkdir -p $CFG_DIR
fi

# Link nvim config directory
if [[ ! -e $NVIM_DIR ]]; then
	echo "linking ${NVIM_DIR}"
	ln -s $VIM_DIR $NVIM_DIR
fi

# Link nvim config
if [[ -e $NVIM_CFG ]]; then
	echo "${NVIM_CFG} exists, skipping"
else
	echo "linking ${NVIM_CFG}"
	ln -s $($READLINK -f vimrc) $NVIM_CFG
fi

# Link .ideavimrc
if [[ -e $IDEAVIMRC ]]; then
	echo "${IDEAVIMRC} exists, skipping"
else
	echo "linking ${IDEAVIMRC}"
	ln -s $($READLINK -f ideavimrc) $IDEAVIMRC
fi

# Link .vrapperrc
if [[ -e $VRAPPERRC ]]; then
	echo "${VRAPPERRC} exists, skipping"
else
	echo "linking ${VRAPPERRC}"
	ln -s $($READLINK -f vrapperrc) $VRAPPERRC
fi

# Link .tmux.conf
if [[ -e $TMUXCONF ]]; then
	echo "${TMUXCONF} exists, skipping"
else
	echo "linking ${TMUXCONF}"
	ln -s $($READLINK -f tmux.conf) $TMUXCONF
fi

# Link .gitcompletion.bash
if [[ -e $GITCOMPLETION ]]; then
	echo "${GITCOMPLETION} exists, skipping"
else
	echo "linking ${GITCOMPLETION}"
	ln -s $($READLINK -f git-completion.bash) $GITCOMPLETION
fi

CC=`which gcc || which clang`

# Create required bin directory
if [[ ! -e $HOME_RBIN ]]; then
	echo "creating directory ${HOME_RBIN}"
  mkdir $HOME_RBIN
fi

# Create home bin directory
if [[ ! -e $HOME_BIN ]]; then
	echo "creating directory ${HOME_BIN}"
  mkdir $HOME_BIN
fi

if [[ ! -z $CC ]]; then
  # Compile ftime.c
  echo "Building ftime utility with ${CC}"
  $CC -O2 -o ftime ftime.c

  # Link ftime
  if [[ -e $HOME_RBIN ]]; then
    echo "Adding ftime utility to ~/rbin"
    rm $HOME_RBIN/ftime
    cp ftime $HOME_RBIN/ftime
  elif [[ -e $HOME_BIN ]]; then
    echo "Adding ftime utility to ~/bin"
    rm $HOME_BIN/ftime
    cp ftime $HOME_BIN/ftime
  fi
fi

# Setup vim-plug
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

