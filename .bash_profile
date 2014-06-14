# ~/.bashrc: executed by bash(1) for non-login shells.

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines in the history. See bash(1) for more options
# don't overwrite GNU Midnight Commander's setting of `ignorespace'.
export HISTCONTROL=$HISTCONTROL${HISTCONTROL+,}ignoredups
# ... or force ignoredups and ignorespace
export HISTCONTROL=ignoreboth

# Append to the history file, don't overwrite it.
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi


# Show git branch in shell info
git_branch() {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}


if [ "$color_prompt" = yes ]; then
    PS1="${debian_chroot:+($debian_chroot)}\[\033[01;11m\]\$(git_branch) \[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ "
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

STARTCOLOR='\e[1;40m';
ENDCOLOR="\e[0m"

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"		
#    PS1="\[$STARTCOLOR${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$ENDCOLOR $PS1 "		
#    PS1="\e[0;34m\u@\h \w> \e[m"
    ;;
*)
    ;;
esac

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

#if [ -f ~/.bash_aliases ]; then
#    . ~/.bash_aliases
#fi

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    eval "`dircolors -b`"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    #alias grep='grep --color=auto'
    #alias fgrep='fgrep --color=auto'
    #alias egrep='egrep --color=auto'
fi

alias ec="emacsclient /$HOME/.bash_profile"
alias rf="source $HOME/.bash_profile"

# some more ls aliases
alias ll='ls -hsAl'
#alias la='ls -A'
#alias l='ls -CF'

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi

export EDITOR=emacsclient
export PATH=/usr/local/src/go_appengine:${HOME}/src:${HOME}/src/tools:${HOME}/go/bin:.:$PATH

alias e="emacsclient -nw $1"
alias ec="e /$HOME/.bash_profile"
alias rf="source $HOME/.bash_profile"
alias tm="tmux attach -d -t main"
alias tw="tmux attach -d -t work"
alias tl="tmux list-sessions"
alias tc="tmux new -s $1"
alias ta="tmux attach -d -t $1"

alias pp="git pull && git push"

export GOPATH=${HOME}/go:${HOME}:$GOPATH
export PYTHONPATH=.:..:/home/$USER/src/python-blink1

# SSH-agent setup via
# http://superuser.com/questions/141044/sharing-the-same-ssh-agent-among-multiple-login-sessions.
start-ssh-agent() {
  # Starts ssh-agent and stores the SSH_AUTH_SOCK / SSH_AGENT_PID for
  # later reuse.
  ssh-agent -s > ~/.ssh-agent.conf 2> /dev/null
  source ~/.ssh-agent.conf > /dev/null
}

# Time a key should be kept, in seconds.
key_ttl=$((3600*8))

if [ -f ~/.ssh-agent.conf ] ; then
  # Found previous config, try loading it.
  source ~/.ssh-agent.conf > /dev/null
	# List all identities the SSH agent knows about.
  ssh-add -l > /dev/null 2>&1
  stat=$?
  # $?=0 means the socket is there and it has a key
  if [ $stat -eq 1 ] ; then
		# $?=1 means the socket is there but contains no key
    ssh-add -t $key_ttl > /dev/null 2>&1
  elif [ $stat -eq 2 ] ; then
		# $?=2 means the socket is not there or broken
    rm -f $SSH_AUTH_SOCK
    start-ssh-agent
    ssh-add -t $key_ttl > /dev/null 2>&1
  fi
else
	# No existing config.
  start-ssh-agent
  ssh-add -t $key_ttl > /dev/null 2>&1
fi

# Include extra Arch aliases.
source $HOME/.arch_aliases
source $HOME/.meta_aliases

# Don't scatter __pycache__ directories all over the place.
export PYTHONDONTWRITEBYTECODE=1
