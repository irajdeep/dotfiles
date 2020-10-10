HISTSIZE=500000

# ---------------------- GLOBAL -------------------------
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# ---------------------- PROMPT -------------------------
#C_NONE='\[\033[0m\]'
#C_RED='\[\033[0;31m\]'
#C_GREEN='\[\033[0;32m\]'
#C_BLUE='\[\033[0;34m\]'
#C_YELLOW='\[\033[1;33m\]'
#C_WHITE='\[\033[1;37m\]'
#C_BOLD='\[\e[1;91m\]'

BLACK="\[\033[0;30m\]"
BLACKB="\[\033[1;30m\]"
RED="\[\033[0;31m\]"
REDB="\[\033[1;31m\]"
GREEN="\[\033[0;32m\]"
GREENB="\[\033[1;32m\]"
YELLOW="\[\033[0;33m\]"
YELLOWB="\[\033[1;33m\]"
BLUE="\[\033[0;34m\]"
BLUEB="\[\033[1;34m\]"
PURPLE="\[\033[0;35m\]"
PURPLEB="\[\033[1;35m\]"
CYAN="\[\033[0;36m\]"
CYANB="\[\033[1;36m\]"
WHITE="\[\033[0;37m\]"
WHITEB="\[\033[1;37m\]"
RESET="\[\033[0;0m\]"

source ~/.bashrc

git_branch () {
    if git rev-parse --git-dir >/dev/null 2>&1
        # then echo -e "" git:\($(git branch 2>/dev/null| sed -n '/^\*/s/^\* //p')\)
        then echo -e "" \[$(git branch 2>/dev/null| sed -n '/^\*/s/^\* //p')\]
    else
        echo ""
    fi
}

git_color() {
    local STATUS=`git status 2>&1`
    if [[ "$STATUS" == *'Not a git repository'* ]]
        then echo "" # nothing
    else
        if [[ "$STATUS" != *'working tree clean'* ]]
            then echo -e '\033[0;31m' # red if need to commit
        else
            if [[ "$STATUS" == *'Your branch is ahead'* ]]
                then echo -e '\033[0;33m' # yellow if need to push
            else
                echo -e '\033[0;32m' # else green
            fi
        fi
    fi
}

export PS1=$PURPLE'[\w]\e[0m$(git_color)$(git_branch)'$WHITE'\$\n '
# ---------------------- PLATFORM SPECIFIC SETTINGS -------------------------
case $(uname) in
    Linux)
        alias lsa='ls -lah --color=auto'
        alias ls='ls  --color=auto'
        alias iptbleshow='iptables -L -n -t nat'
        alias bcopy='xclip -i -sel clip'
        alias bpaste='xclip -o -sel clip'
        ;;
    Darwin)
        export CLICOLOR=1
        export LSCOLORS=gxBxhxDxfxhxhxhxhxcxcx
        alias lsa='ls -lah'
        alias ls='ls -lh'
        ;;
esac

# ---------------------- ENVIRONMENT -------------------------
export GOPATH=$HOME/go
export PATH=/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/sbin
export PATH=$PATH:/Users/rdas/Downloads/apache-maven-3.5.4/bin
export PATH=$PATH:/usr/local/go/bin
export PATH=$PATH:/Users/rdas/go/bin
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib
# ---------------------- ALIAS -------------------------
alias tmux="TERM=screen-256color-bce tmux"
alias tree='tree -F'

# ---------------------- FUNCTIONS -------------------------
function gobuild_controller() {
    env GOOS=linux go build
}

function remove_images_none() {
    docker rmi $(docker images | grep "<none>" | awk '{print $3}')
}

function linecount() {
    find . -name "*.$1" | xargs wc -l
}

function find_replace() {
    pt -l "$1" | xargs perl -pi -E "s/$1/$2/g"
}

function go_cover() {
    go test -cover -coverprofile /dev/stderr 2>&1 >/dev/null | go tool cover -func /dev/stdin
}

function set_namespace() {
    kubectl config set-context --current --namespace=$1
}

function cluster_status() {
    kc get cs
}

function current_namespace() {
    kubectl config view --minify --output 'jsonpath={..namespace}'
}

alias rdas="cd \$GOPATH/src"
alias kc="kubectl"
alias kfc="kubefedctl"
function comp {
    g++ -w  -std=c++11 -Wall -Wextra -Werror $1
}

function run {
    if [ -e input.txt ]
    then
        ./a.out < input.txt
    else
        ./a.out
    fi
}

# $1 is methid name $2 absolute file path of the test file
function go_test_method() {
    go test -v -run "${1}" "${2}"
}

function tcp_port() {
    sudo tcpdump -i lo udp port "${1}" -vv -A
}
#FIX THIS
export GO111MODULE=auto
export PATH=$PATH:/usr/local/go/bin
export BASH_SILENCE_DEPRECATION_WARNING=1

[ -s "/Users/rajdeepdas/.jabba/jabba.sh" ] && source "/Users/rajdeepdas/.jabba/jabba.sh"

export N_PREFIX="$HOME/n"; [[ :$PATH: == *":$N_PREFIX/bin:"* ]] || PATH+=":$N_PREFIX/bin"  # Added by n-install (see http://git.io/n-install-repo).
