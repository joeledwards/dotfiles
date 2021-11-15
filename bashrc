DO_TIME_LOG=${LOG_BASH_INIT}

function time_log () {
  if [[ $DO_TIME_LOG -eq 1 ]]; then
    echo "$($HOME/rbin/ftime iso-bash) => ${@}"
  fi
}

time_log "Configuring bash ..."

# Setup items
time_log "source ~/.bash_head ..."
bash_head=~/.bash_head
if [ -f $bash_head ]; then
    . $bash_head
fi

# ===== BASH Color Escape Sequences =====
time_log "constants ..."
# Reset
Color_Off='\[\e[0m\]'       # Text Reset

# Regular Colors
Black='\[\e[0;30m\]'        # Black
Red='\[\e[0;31m\]'          # Red
Green='\[\e[0;32m\]'        # Green
Yellow='\[\e[0;33m\]'       # Yellow
Blue='\[\e[0;34m\]'         # Blue
Purple='\[\e[0;35m\]'       # Purple
Cyan='\[\e[0;36m\]'         # Cyan
White='\[\e[0;37m\]'        # White

# Bold
BBlack='\[\e[1;30m\]'       # Black
BRed='\[\e[1;31m\]'         # Red
BGreen='\[\e[1;32m\]'       # Green
BYellow='\[\e[1;33m\]'      # Yellow
BBlue='\[\e[1;34m\]'        # Blue
BPurple='\[\e[1;35m\]'      # Purple
BCyan='\[\e[1;36m\]'        # Cyan
BWhite='\[\e[1;37m\]'       # White

# Underline
UBlack='\[\e[4;30m\]'       # Black
URed='\[\e[4;31m\]'         # Red
UGreen='\[\e[4;32m\]'       # Green
UYellow='\[\e[4;33m\]'      # Yellow
UBlue='\[\e[4;34m\]'        # Blue
UPurple='\[\e[4;35m\]'      # Purple
UCyan='\[\e[4;36m\]'        # Cyan
UWhite='\[\e[4;37m\]'       # White

# Background
On_Black='\[\e[40m\]'       # Black
On_Red='\[\e[41m\]'         # Red
On_Green='\[\e[42m\]'       # Green
On_Yellow='\[\e[43m\]'      # Yellow
On_Blue='\[\e[44m\]'        # Blue
On_Purple='\[\e[45m\]'      # Purple
On_Cyan='\[\e[46m\]'        # Cyan
On_White='\[\e[47m\]'       # White

# High Intensity
IBlack='\[\e[0;90m\]'       # Black
IRed='\[\e[0;91m\]'         # Red
IGreen='\[\e[0;92m\]'       # Green
IYellow='\[\e[0;93m\]'      # Yellow
IBlue='\[\e[0;94m\]'        # Blue
IPurple='\[\e[0;95m\]'      # Purple
ICyan='\[\e[0;96m\]'        # Cyan
IWhite='\[\e[0;97m\]'       # White

# Bold High Intensity
BIBlack='\[\e[1;90m\]'      # Black
BIRed='\[\e[1;91m\]'        # Red
BIGreen='\[\e[1;92m\]'      # Green
BIYellow='\[\e[1;93m\]'     # Yellow
BIBlue='\[\e[1;94m\]'       # Blue
BIPurple='\[\e[1;95m\]'     # Purple
BICyan='\[\e[1;96m\]'       # Cyan
BIWhite='\[\e[1;97m\]'      # White

# High Intensity backgrounds
On_IBlack='\[\e[0;100m\]'   # Black
On_IRed='\[\e[0;101m\]'     # Red
On_IGreen='\[\e[0;102m\]'   # Green
On_IYellow='\[\e[0;103m\]'  # Yellow
On_IBlue='\[\e[0;104m\]'    # Blue
On_IPurple='\[\e[10;95m\]'  # Purple
On_ICyan='\[\e[0;106m\]'    # Cyan
On_IWhite='\[\e[0;107m\]'   # White

off=$Color_Off

SuccessSymbol='\342\234\223'
FailureSymbol='\342\234\227'

date_color=$Green
time_color=$Yellow
duration_color=$Blue
pyver_color=$White
venv_color=$Yellow

success_color=$Green
failure_color=$Red

user_color=$Blue
host_color=$Red
path_color=$Cyan

root_user_color=$Red
root_host_color=$Blue

# ===== Git Command-Line Completion & PS1 Prefix =====
# Git completion functions
time_log "git PS1 ..."

project_color=$Yellow
branch_color=$White
describe_color=$Green

function git_ps1() {
  local project=$(git rev-parse --show-toplevel 2>/dev/null | xargs -L 1 basename 2>/dev/null)

  if [[ ! -z "${project}" ]]; then
    local project_str="${off}[${project_color}${project}$off:"

    local branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
    local branch_str="${branch_color}${branch}${off}:"

    local describe=$(git describe --always 2>/dev/null)
    local describe_str="${describe_color}${describe}${off}]\n"

    echo "${project_str}${branch_str}${describe_str}"
  fi
}

time_log "git completion ..."
git_completion="${HOME}/.git-completion.bash"
if [[ -e $git_completion ]]; then
  . $git_completion
fi


# ==== Need these early on ====
time_log "local binaries ..."

home_bin=~/bin
if [ -x $home_bin ]; then
    PATH=$PATH:$home_bin
fi
home_rbin=~/rbin
if [ -x $home_rbin ]; then
    PATH=$home_rbin:$PATH
fi

# ===== The timestamp PS1 =====
time_log "timing info ..."

function __year() {
    printf "`date +%Y`"
}
function __month() {
    printf "`date +%m`"
}
function __day() {
    printf "`date +%d`"
}
function __hour() {
    printf "`date +%H`"
}
function __minute() {
    printf "`date +%M`"
}
function __second() {
    printf "`date +%S`"
}

function exexists() {
  local exe_name=$1
  which $exe_name 2>&1 > /dev/null
  echo $?
}

function bash_time() {
  echo "$date_color\$(__year)\
$off-\
$date_color\$(__month)\
$off-\
$date_color\$(__day)\
$off \
$time_color\$(__hour)\
$off:\
$time_color\$(__minute)\
$off:\
$time_color\$(__second)\
$off"
}

FTIME_FOUND=$(exexists ftime)

function fmtime() {
  if [[ $FTIME_FOUND -eq 0 ]]; then
    ftime $@
  elif [[ $1 == "format" ]]; then
    echo ""
  elif [[ $1 == "bash" ]]; then
    bash_time
  else
    echo "0"
  fi
}

function timer_now() {
  fmtime ns
}

function timer_start() {
  timer_start=${timer_start:-$(timer_now)}
}

function timer_stop() {
  local delta=$(($(timer_now) - $timer_start))
  timer_show=$(fmtime format $delta)
  unset timer_start
}

time_log "venv ..."
function venv_info() {
  local deactivate_type=`type -t deactivate`
  if [ "${deactivate_type}" = "function" ]; then
    local venv_path=`echo $VIRTUAL_ENV`
    local venv_name=""
    if [ -z "$venv_path" ]; then
      venv_name="(${pyver_color}??${off}) "
    else
      local venv_base=`basename ${venv_path}`
      venv_name="(${pyver_color}${venv_base}${off}) "
    fi
    printf "${venv_color}0-0${off} ${venv_name}-> "
  else
    printf ""
  fi
}

time_log "prompt ..."
function set_prompt() {
  last_result=$? # Must come first

  if [[ $last_result == 0 ]]; then
    result="${success_color}${last_result} ${SuccessSymbol}${off}"
  else
    result="${failure_color}${last_result} ${FailureSymbol}${off}"
  fi

  timer_stop

  TIME_PS1="\
$off[\
$(fmtime bash)\
$off] \
$duration_color\
$timer_show\
$off \
| $result |\
\n"

  # ===== The standard PS1 =====
  prompt_symbol=λ
  if [[ $SPECIAL_CHARACTERS == false ]]; then
     prompt_symbol=\$
  fi

  if [ `id -u` -eq 0 ]; then
      # Swap colors if we are root
      user_color=$root_user_color
      host_color=$root_host_color
      prompt_symbol=\#
  fi

  PY_VENV="$(venv_info)"

  BASE_PS1="\
$off\
$user_color\u\
$off@\
$host_color\h\
$off:\
$path_color\w\
$off$prompt_symbol "

  PS1="${TIME_PS1}$(git_ps1)${BASE_PS1}${PY_VENV}"
}

time_log "traps ..."
trap 'timer_start' DEBUG
PROMPT_COMMAND='set_prompt'

#a -- black
#b -- red
#c -- green
#d -- brown
#e -- blue
#f -- magenta
#g -- cyan
#h -- light gray
#A -- bold black, usually shows up as dark gray
#B -- bold red
#C -- bold green
#D -- bold brown, usually shows up as yellow
#E -- bold blue
#F -- bold magenta
#G -- bold cyan
#H -- bold light gray; looks like bright white
#x -- default foreground or background

#DIR=Ex
#SYM_LINK=Gx
#SOCKET=Fx
#PIPE=dx
#EXE=Cx
#BLOCK_SP=Dx
#CHAR_SP=Dx
#EXE_SUID=hb
#EXE_GUID=ad
#DIR_STICKY=Ex
#DIR_WO_STICKY=Ex

time_log "colors ..."

export LSCOLORS=GxFxCxDxBxegedabagaced # BSD/OSX
#export LS_COLORS=GxFxCxDxBxegedabagaced # Linux
export CLICOLOR=1

ls_color=""
# ===== Aliases =====
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    ls_color=" --color=auto"

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

time_log "aliases ..."

# ls aliases
alias ls="ls${ls_color} -p"
alias ll="ls${ls_color} -l"
alias la="ls${ls_color} -a"
alias lstree="tree -if --noreport"
alias githash="git describe --always --abbrev=40"
alias netproc="netstat -lantp"

# General aliases file
bash_aliases=~/.bash_aliases
if [ -f $bash_aliases ]; then
    . $bash_aliases
fi

# Server login aliases file
server_logins=~/.server-login-aliases.bash
if [ -f $server_logins ]; then
    . $server_logins
fi


# ===== History Configurations =====
time_log "history ..."
HISTSIZE=8192
HISTFILESIZE=16384
HISTCONTROL=ignoredups # ignorespace | ignoreboth
HISTTIMEFORMAT="%D - %T : "
shopt -s histappend
shopt -s checkwinsize

time_log "PATH ..."
export PATH

python_lib=~/lib/python
if [ -x $python_lib ]; then
    PYTHONPATH=$python_lib:$PYTHONPATH
fi
export PYTHONPATH

export EDITOR=vim
export VISUAL=view
export GIT_SSH=`which ssh`

# Don't dump cores larger than this
time_log "ulimit ..."
ulimit -c 500000000 # 500 MB

# User-only writes
time_log "umask ..."
umask 0022

# Vi key-bindings for shell (default is emacs)
time_log "key-bindings ..."
set -o vi

# Additional items (wrap up)
time_log "source ~/.bash_tail ..."
bash_tail=~/.bash_tail
if [ -f $bash_tail ]; then
    . $bash_tail
fi

time_log "bash ready."
