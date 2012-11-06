# ===== BASH Color Escape Sequences =====
# Reset
Color_Off='\e[0m'       # Text Reset

# Regular Colors
Black='\e[0;30m'        # Black
Red='\e[0;31m'          # Red
Green='\e[0;32m'        # Green
Yellow='\e[0;33m'       # Yellow
Blue='\e[0;34m'         # Blue
Purple='\e[0;35m'       # Purple
Cyan='\e[0;36m'         # Cyan
White='\e[0;37m'        # White

# Bold
BBlack='\e[1;30m'       # Black
BRed='\e[1;31m'         # Red
BGreen='\e[1;32m'       # Green
BYellow='\e[1;33m'      # Yellow
BBlue='\e[1;34m'        # Blue
BPurple='\e[1;35m'      # Purple
BCyan='\e[1;36m'        # Cyan
BWhite='\e[1;37m'       # White

# Underline
UBlack='\e[4;30m'       # Black
URed='\e[4;31m'         # Red
UGreen='\e[4;32m'       # Green
UYellow='\e[4;33m'      # Yellow
UBlue='\e[4;34m'        # Blue
UPurple='\e[4;35m'      # Purple
UCyan='\e[4;36m'        # Cyan
UWhite='\e[4;37m'       # White

# Background
On_Black='\e[40m'       # Black
On_Red='\e[41m'         # Red
On_Green='\e[42m'       # Green
On_Yellow='\e[43m'      # Yellow
On_Blue='\e[44m'        # Blue
On_Purple='\e[45m'      # Purple
On_Cyan='\e[46m'        # Cyan
On_White='\e[47m'       # White

# High Intensity
IBlack='\e[0;90m'       # Black
IRed='\e[0;91m'         # Red
IGreen='\e[0;92m'       # Green
IYellow='\e[0;93m'      # Yellow
IBlue='\e[0;94m'        # Blue
IPurple='\e[0;95m'      # Purple
ICyan='\e[0;96m'        # Cyan
IWhite='\e[0;97m'       # White

# Bold High Intensity
BIBlack='\e[1;90m'      # Black
BIRed='\e[1;91m'        # Red
BIGreen='\e[1;92m'      # Green
BIYellow='\e[1;93m'     # Yellow
BIBlue='\e[1;94m'       # Blue
BIPurple='\e[1;95m'     # Purple
BICyan='\e[1;96m'       # Cyan
BIWhite='\e[1;97m'      # White

# High Intensity backgrounds
On_IBlack='\e[0;100m'   # Black
On_IRed='\e[0;101m'     # Red
On_IGreen='\e[0;102m'   # Green
On_IYellow='\e[0;103m'  # Yellow
On_IBlue='\e[0;104m'    # Blue
On_IPurple='\e[10;95m'  # Purple
On_ICyan='\e[0;106m'    # Cyan
On_IWhite='\e[0;107m'   # White

# ===== Git Command-Line Completion & PS1 Prefix =====
# Git completion functions
completion_file="${HOME}/.git-completion.bash"

GIT_PS1=""
if [ -e $completion_file ]; then
    source $completion_file
    repo_color=$Purple
    branch_color=$Green
    describe_color=$Yellow
    off=$Color_Off

    GIT_PS1="\
\$(__gitproject \"[\
\[$repo_color\]%s\
\[$off\]:\
\")\
\
\$(__git_ps1 \"\
\[$branch_color\]%s\
\[$off\]:\
\")\
\
\$(__gitdescribe \"\
\[$describe_color\]%s\
\[$off\]\
]\n\n\")\
"
fi

# ===== The standard PS1 =====
user_color=$Blue
host_color=$Red
path_color=$Cyan
off=$Color_Off

if [ `id -u` -eq 0 ]; then
    # Swap colors if we are root
    temp_color=$user_color
    user_color=$host_color
    host_color=$temp_color
fi

BASE_PS1="\
\[$user_color\]\u\
\[$off\]@\
\[$host_color\]\h\
\[$off\]:\
\[$path_color\]\w\
\[$off\]\$ "

export PS1="${GIT_PS1}${BASE_PS1}"

ls_color=""
# ===== Aliases =====
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolord -b ~/.dircolord)" || eval "$(direcolord -b)"
    ls_color=" --color=auto"

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

alias ls="ls${ls_color} -p"
alias ll="ls${ls_color} -l"
alias la="ls${ls_color} -a"

# General aliases file
bash_aliases=~/.bash_aliases
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# Server login aliases file
server_logins=~/.server-login-aliases.bash
if [ -f $server_logins ]; then
    source $server_logins
fi

# Other Aliases

# ===== History Configurations =====
HISTSIZE=8192
HISTFILESIZE=16384
HISTCONTROL=ignoredups # ignorespace | ignoreboth
shopt -s histappend
shopt -s checkwinsize

export PATH=/usr/local/git/bin:$HOME/opt/bin:$PATH:$HOME/bin
export EDITOR=vim
export VIEWER=view
export GIT_SSH=`which ssh`

# Don't dump cores larger than this
ulimit -c 500000000 # 500 MB

# Vi key-bindings for shell (default is emacs)
set -o vi

