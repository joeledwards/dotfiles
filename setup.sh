#!/bin/bash

BASHRC=$HOME/.bashrc
VIMRC=$HOME/.vimrc
VIM_DIR=$HOME/.vim
VRAPPERRC=$HOME/.vrapperrc

BUNDLE_DIR=$HOME/.vim/bundle
VUNDLE_DIR=$BUNDLE_DIR/Vundle.vim

HOME_RBIN=$HOME/rbin
HOME_BIN=$HOME/bin

# Link .bashrc
if [[ -e $BASHRC ]]; then
	echo "${BASHRC} exists, skipping"
else
	echo "linking ${BASHRC}"
	ln -s `readlink -f bashrc` $BASHRC
fi

# Link .vimrc
if [[ -e $VIMRC ]]; then
	echo "${VIMRC} exists, skipping"
else
	echo "linking ${VIMRC}"
	ln -s `readlink -f vimrc` $VIMRC
fi

# Link .vim
if [[ -e $VIM_DIR ]]; then
	echo "${VIM_DIR} exists, skipping"
else
	echo "linking ${VIM_DIR}"
	ln -s `readlink -f vim` $VIM_DIR
fi

# Link .vrapperrc
if [[ -e $VRAPPERRC ]]; then
	echo "${VRAPPERRC} exists, skipping"
else
	echo "linking ${VRAPPERRC}"
	ln -s `readlink -f vrapperrc` $VRAPPERRC
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

if [[ -e $BUNDLE_DIR ]]; then
  echo "${BUNDLE_DIR} exists, skipping"
else
  echo "creating ${BUNDLE_DIR}"
  mkdir $BUNDLE_DIR
fi

if [[ -e $VUNDLE_DIR ]]; then
  echo "${VUNDLE_DIR} exists, skipping"
else
  echo "cloning Vundle repository to ${VUNDLE_DIR}"
  git clone git://github.com/VundleVim/Vundle.vim.git ${VUNDLE_DIR}
fi

