#!/bin/bash

BASHRC=$HOME/.bashrc
VIMRC=$HOME/.vimrc
VIM_DIR=$HOME/.vim
VRAPPERRC=$HOME/.vrapperrc

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

