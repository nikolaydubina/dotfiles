# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# shell
HISTCONTROL=ignoreboth
HISTFILESIZE=2000
HISTSIZE=1000

shopt -s histappend
shopt -s checkwinsize

export CLICOLOR=1
export LSCOLORS=ExFxBxDxCxegedabagacad
export PS1='$(whoami)@$(hostname):$(pwd)$ '

# alias
alias fp='fpp'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias l='ls -alFh'
alias pip='pip3.6'
alias pip_update='pip freeze --local | grep -v '^\-e' | cut -d = -f 1  | xargs -n1 pip install -U'

eval "$(thefuck --alias fk)"

# naive encrypt
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

# set MAC address to random
function randmac {
    sudo ifconfig en0 ether $(openssl rand -hex 6 | sed 's%\(..\)%\1:%g; s%.$%%')
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

# torch
. /Users/nikolay/torch/install/bin/torch-activate

# go
export GOPATH=/usr/local/go/bin
export PATH=$PATH:$GOPATH/bin

# redis
export REDISCONFIG=/usr/local/etc/redis.conf

# Added by GraphLab Create Launcher v3.0.1
export PATH="/Users/nikolay/Workplace/anaconda/bin:$PATH"

# homebrew
export HOMEBREW_NO_ANALYTICS=1
