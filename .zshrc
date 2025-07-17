autoload -Uz compinit
compinit
zstyle ':completion:*' menu select
zstyle ':completion:*' rehash true
#bindkey -v

# history
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=1000000
setopt appendhistory
setopt sharehistory
setopt incappendhistory

export CLICOLOR=1
export LSCOLORS=ExFxBxDxCxegedabagacad

export HOMEBREW_CASK_OPTS=--require-sha
export HOMEBREW_NO_INSECURE_REDIRECT=1
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

alias fp='fpp'
alias grep='grep --color=auto'
alias l='ls -alFh'

eval "$(/opt/homebrew/bin/brew shellenv)"
export PATH="/opt/homebrew/opt/binutils/bin:$PATH"

export GOPATH=$(go env GOPATH)
export GOPRIVATE=github.com/ndx-technologies

export PATH=$PATH:/usr/local/bin
export PATH=$PATH:$(go env GOPATH)/bin
export PATH=$PATH:/Users/nikolaydubina/.kubescape/bin 
export PATH=$PATH:/Users/nikolaydubina/Workspace/dotfiles

