if [ -r ~/.bashrc ]; then
   source ~/.bashrc
fi

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
export PS1='$(pwd)$ '
export HOMEBREW_NO_ANALYTICS=1

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

# alias
alias fp='fpp'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias l='ls -alFh'
alias datef='date "+%d-%m-%Y"'
alias pip_update='pip freeze --local | grep -v '^\-e' | cut -d = -f 1  | xargs -n1 pip install -U'
alias vid='vi $(date +%F).md'
alias du='du -h'
