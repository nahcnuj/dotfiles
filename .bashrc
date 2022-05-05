# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

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

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
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

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [[ $PS1 && -f $HOME/usr/share/bash-completion/bash_completion ]]; then
    . $HOME/usr/share/bash-completion/bash_completion
  elif [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

function winpath()
{
  if [ -p /dev/stdin ]; then
    input_path=$(cat -)
  else
    input_path=$(echo $@)
  fi
  /bin/readlink -f $input_path | sed -e "s|^\(/mnt/\([a-z]\)\)\(.*\)|\U\2:\E\3|" -e "s|/|\\\\|g"
}

function linuxpath()
{
  if [ -p /dev/stdin ]; then
    input_path=$(cat -)
  else
    input_path=$(echo $@)
  fi

  echo $input_path | sed -e "s|\\\\|/|g" -e "s|^\([A-Za-z]\)\:/\(.*\)|/mnt/\L\1\E/\2|"
}

### added by user below

# ssh-agent (avoid running duplicate process)
SSH_AGENT_FILE=$HOME/.ssh-agent
test -f $SSH_AGENT_FILE && source $SSH_AGENT_FILE
if ! ssh-add -l >/dev/null 2>&1; then
    ssh-agent >$SSH_AGENT_FILE
    source $SSH_AGENT_FILE
    ssh-add $HOME/.ssh/id_rsa
fi

if [ ! -f $HOME/.git-completion.bash ]; then
    wget -O $HOME/.git-completion.bash https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash
    chmod u+x $HOME/.git-completion.bash
fi
source $HOME/.git-completion.bash

if [ ! -f $HOME/.git-prompt.sh ]; then
    wget -O $HOME/.git-prompt.sh https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh
    chmod u+x $HOME/.git-prompt.sh
fi
source $HOME/.git-prompt.sh

export PS1='\[\e[1;32m\]\u@\h\[\e[1;33m\]$(__git_ps1) \[\e[1;34m\]\w \[\e[m\]\n\$ '

export PROMPT_COMMAND='history -a;history -r;'

exit() {
    if [[ -z $TMUX ]]; then
        builtin exit
    else
        tmux detach
    fi
}

if command -v peco >/dev/null ; then
    if [[ -z "$TMUX" ]] && [[ -z "$VSCODE_PID" ]] && [[ "$TERM_PROGRAM" != "vscode" ]] ; then
        IDs=`tmux list-sessions`
        [[ -z "$IDs" ]] && tmux new-session
        not_attach_session=
        create_new_session="Create a new session"
        IDs="${not_attach_session}\n$IDs\n${create_new_session}"
        ID="`echo -e "$IDs" | peco | cut -d: -f1`"
        if [[ "$ID" = "${create_new_session}" ]]; then
            tmux new-session
        elif [[ -n "$ID" ]]; then
            tmux attach-session -t "$ID"
        else
            # Start terminal without tmux
            :
        fi
    fi
fi

export DISPLAY=$(cat /etc/resolv.conf | grep nameserver | awk '{print $2}'):0

export GOROOT=/usr/local/go
export GOPATH=$HOME/go
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin

# make PATH unique  https://qiita.com/key-amb/items/ce39b0c85b30888e1e3b
_path=""
for _p in $(echo $PATH | tr ':' ' '); do
    case ":${_path}:" in
        *:"${_p}":* )
            ;;
        * )
            if [ "$_path" ]; then
              _path="$_path:$_p"
            else
              _path=$_p
            fi
            ;;
    esac
done
PATH=$_path

unset _p
unset _path

command -v golangci-lint >/dev/null && source <(golangci-lint completion bash) || true

if command -v trans >/dev/null ; then
    alias trans-en="trans -b en:ja"
fi
