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

color_prompt=yes
if ! [ -x /usr/bin/tput ] || ! tput setaf 1 >&/dev/null; then
   # We have no color support; not compliant with Ecma-48
   # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
   # a case would tend to support setf rather than setaf.)
   color_prompt=
fi

# echo the current git branch
gitBranch() {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'
}

# echo user and host
userAndHost() {
  local lgreen='\[\033[01;32m\]'
  local normal='\[\033[00m\]'
  local dgray='\[\033[1;30m\]'
  echo "${lgreen}\u@\h${dgray}人${normal}"
}

# echo current working directory
workDir() {
  local lblue='\[\033[01;34m\]'
  local normal='\[\033[00m\]'
  echo "${lblue}\w${normal}"
}

PROMPT_COMMAND=__prompt_command

# Set prompt according to exit status and other info.
__prompt_command() {
  local EXIT="$?"

  local prompt="►"

  local dgray='\[\033[1;30m\]'
  local green='\[\033[00;32m\]'
  local lwhite='\[\033[01;11m\]'
  local normal='\[\033[00m\]'
  local lcyan='\[\033[1;36m\]'
  local red='\[\e[0;31m\]'

  local pcolor="$green"
  if [ $EXIT != 0 ]; then
    pcolor="$red"
  fi
  if [ "$color_prompt" = yes ]; then
    PS1="${lwhite}\$(gitBranch)${dgray}木${normal}$(userAndHost)$(workDir) \n${pcolor}${prompt}$normal "
  else
    PS1="\$(gitBranch)木$(userAndHost)$(workDir) \n${prompt}"
  fi
}

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"		
    ;;
*)
    ;;
esac

# Pull in useful functions.
BASH_FUNCS="$HOME/src/hkjn.me/scripts/bash_funcs.sh"
if [ -e "$BASH_FUNCS" ]; then
  source "$BASH_FUNCS"
else
	echo "No '$BASH_FUNCS' found. Try 'go get hkjn.me/scripts'?"
fi

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    eval "`dircolors -b`"
    alias ls='ls --color=auto'
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
[ -f /etc/bash_completion ] && source /etc/bash_completion

alias pp="git pull && git push"
alias gdc="git diff --cached"
alias gs="git status"

alias e="emacsclient -nw $1"
alias ec="e $HOME/.bash_profile"
alias rf="[ -e $HOME/.bash_profile ] && source $HOME/.bash_profile || source $HOME/.bashrc"
alias tc="tmux new -s $1"
alias ta="tmux attach -d -t $1"
alias ll='ls -hsAl'
alias mp="mplayer -af scaletempo $@"
alias mp50="mplayer -af scaletempo -fs -panscanrange -5 $@"
alias xclip="xclip -selection c"
alias shlogs="less ${HOME}/.shell_logs/${HOSTNAME}"

export LANG="en_US.UTF-8"
export EDITOR=nano
export GOPATH=${HOME}
export PATH=/usr/local/homebrew/bin:/usr/local/homebrew/sbin:/usr/local/homebrew/Cellar/coreutils/8.25/libexec/gnubin/:${GOPATH}/src/hkjn.me/scripts:${GOPATH}/src/hkjn.me/scripts/tools:${HOME}/bin:.:$PATH
export PYTHONPATH=.:..

# Don't scatter __pycache__ directories all over the place.
export PYTHONDONTWRITEBYTECODE=1

# GPG always wants to know what TTY it's running on. 
export GPG_TTY=$(tty)

export CLOUDSDK_PYTHON=python2

if [ -d ~/google-cloud-sdk ]; then
		# The next line updates PATH for the Google Cloud SDK.
		source "$HOME/google-cloud-sdk/path.bash.inc"

		# The next line enables bash completion for gcloud.
		source "$HOME/google-cloud-sdk/completion.bash.inc"
fi

# Allow current user to connect to X11 socket from any host; required
# to run graphical Docker containers. But not on OS X, since even
# though xhost exists, on at least OS X Mavericks it just stalls
# indefinitely if invoked, preventing new bash sessions.
if which xhost > /dev/null 2>&1 && [ ! -z $DISPLAY ] && [ $(uname) != "Darwin" ]; then
		xhost +si:localuser:$USER >/dev/null
		xhost +si:localuser:root >/dev/null
fi
