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

# Show git branch.
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
    ;;
*)
    ;;
esac

# Pull in useful functions.
if [ -e ${HOME}/src/bash_funcs.sh ]; then
  source ${HOME}/src/bash_funcs.sh
fi

# Alias definitions.

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    eval "`dircolors -b`"
    alias ls='ls --color=auto'
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi

alias pp="git pull && git push"
alias gdc="git diff --cached"
alias gs="git status"

alias e="emacsclient -nw $1"
alias ec="e /$HOME/.bash_profile"
alias rf="source $HOME/.bash_profile"
alias tm="tmux attach -d -t main"
alias tw="tmux attach -d -t work"
alias tl="tmux list-sessions"
alias tc="tmux new -s $1"
alias ta="tmux attach -d -t $1"
alias ll='ls -hsAl'
alias mp="mplayer -af scaletempo $@"
alias mp50="mplayer -af scaletempo -fs -panscanrange -5 $@"

export EDITOR=emacsclient
export GOROOT=/usr/lib/go
export GOPATH=${HOME}
export PYTHONPATH=.:..
export PATH=/usr/local/src/go_appengine:${HOME}/src:${HOME}/src/tools:${HOME}/bin:.:$PATH

# Don't scatter __pycache__ directories all over the place.
export PYTHONDONTWRITEBYTECODE=1

# GPG always wants to know what TTY it's running on. 
export GPG_TTY=$(tty)

export CLOUDSDK_PYTHON=python2

alias sshzero='ssh zero-cloud-1'

if [ -d ~/google-cloud-sdk ]; then
		# The next line updates PATH for the Google Cloud SDK.
		source "~/google-cloud-sdk/path.bash.inc"

		# The next line enables bash completion for gcloud.
		source "/home/zero/google-cloud-sdk/completion.bash.inc"
fi

# Allow current user to connect to X11 socket from any host; required
# to run graphical Docker containers.
if which xhost >/dev/null && [ ! -z $DISPLAY ] ; then
		xhost +si:localuser:$USER >/dev/null
		xhost +si:localuser:root >/dev/null
fi
