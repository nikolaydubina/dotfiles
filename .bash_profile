# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# unfuck
eval "$(thefuck --alias fk)"

# colors
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

alias pip='pip3.5'
alias l='ls -alFh'

export CLICOLOR=1
export LSCOLORS=ExFxBxDxCxegedabagacad

# shortcuts

# naive encrypt. still better than plain text
# $1 : input dir
# $2 : output filename
function encrypt {
    tar --create - --posix --gzip -- $1 | openssl enc -e -aes256 -salt -out $2
}

# naive decrypt
# $1 : input filename  
function decrypt {
    openssl enc -d -aes256 -in $1 | tar --extract --file - --gzip
}

# $1 : # of commands
function history_freq {
    history | \
    awk '{CMD[$2]++;count++;}END { for (a in CMD)print CMD[a] " " CMD[a]/count*100 "% " a;}' | \
    grep -v "./" | \
    column -c3 -s " " -t | sort -nr | nl |  head -n$1
}

# colorize man pages
man() {
    env \
    LESS_TERMCAP_md=$'\e[1;36m' \
    LESS_TERMCAP_me=$'\e[0m' \
    LESS_TERMCAP_se=$'\e[0m' \
    LESS_TERMCAP_so=$'\e[1;40;92m' \
    LESS_TERMCAP_ue=$'\e[0m' \
    LESS_TERMCAP_us=$'\e[1;32m' \
    man "$@"
}

# small how-to
# -----------------
# ssh-copy-id -i <.pub> <user@host>
# ssh-create -t rsa
# tar -czf <in> <out>
# tar -x <in>
# find <path> -name <exp>
# grep -rnw . <name>
# xargs -I {} <command> {}
# grep B | fpp -c 'vim -O'

# torch
. /Users/nikolay/torch/install/bin/torch-activate

# go
export GOPATH=/usr/local/go/bin
export PATH=$PATH:$GOPATH/bin

# redis
export REDISCONFIG=/usr/local/etc/redis.conf
