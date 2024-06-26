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
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\] \W \[\e[91m\]$(__git_ps1 "(%s)")\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# if grep -qi microsoft /proc/version
# then
#   if [ "$color_prompt" = yes ]; then
#       # PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
#       PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]: \[\033[01;34m\]\W \[\e[91m\]$(__git_ps1 "(%s)")\[\033[00m\]$ '
#   else
#       # PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
#       PS1='${debian_chroot:+($debian_chroot)}\u@\h: \W\$ '
#   fi
# fi
# if [[ "$OSTYPE" == "linux-gnu" && `grep -qiv microsoft /proc/version` ]]
# then
#   parse_git_branch() {
#        git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
#   }
#   if [ "$color_prompt" = yes ]; then
#       PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\W \$(parse_git_branch)\[\033[00m\]\$ '
#   else
#       PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
#   fi
# fi
# unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    # PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \W\]$PS1"
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
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

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
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

###
### Definiciones usuario
###

# Functions definitions.
if [ -f ~/.bash_functions ]; then
    . ~/.bash_functions
fi

### editor
export EDITOR='vim'

# ### Idioma
if grep -qi microsoft /proc/version
then
  export LANG=C.UTF-8
fi
if [[ "$OSTYPE" == "linux-gnu" && `grep -qiv microsoft /proc/version` ]]
then
  export LANG=es_CL.UTF-8
fi

# mappings for Ctrl-left-arrow and Ctrl-right-arrow for word moving
if [ -t 1 ] ; then
  bind '"\e[1;5C": forward-word'
  bind '"\e[1;5D": backward-word'
  bind '"\e[5C": forward-word'
  bind '"\e[5D": backward-word'
  bind '"\e\e[C": forward-word'
  bind '"\e\e[D": backward-word'
fi

#### Color:
#### https://unix.stackexchange.com/questions/124407/what-color-codes-can-i-use-in-my-ps1-prompt
#PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
#PS1='\[\033[01;38;5;022m\]\u@\H:\[\033[01;38;5;202m\]\W\$\[\033[00m\] '
#PS1='\[\033[01;38;5;034m\]\u@\H:\[\033[01;38;5;032m\]\W\$\[\033[00m\] '
 PS1='\[\033[01;38;5;036m\]\u@\H:\[\033[01;38;5;033m\]\W\$\[\033[00m\] '

### qt usando gtk skin
### sudo apt-get install --no-install-recommends qt5-style-plugins ### gtk
export QT_QPA_PLATFORMTHEME=gtk2
### qt5 screen factor
export QT_AUTO_SCREEN_SCALE_FACTOR=0

###
### less
###

### color less
### apt-get install --no-install-recommends source-highlight
### updatedb
### locate lesspipe.sh
export LESSOPEN="| /usr/share/source-highlight/src-hilite-lesspipe.sh %s"
# export LESS=' -RS#3NM~g '
export PAGER=less
export LESS='-iMSx4 -RSFX -e'

### phantomjs nodejs
export OPENSSL_CONF=/usr/include/nodejs/openssl.cnf

### timezone wsl2
if grep -qi microsoft /proc/version
then
  export TZ='America/Santiago'
fi

###
### Otras
###


## pyenv
export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

# Docker WSL2
# https://dev.to/bowmanjd/install-docker-on-windows-wsl-without-docker-desktop-34m9
# Launch script for dockerd
if grep -qi microsoft /proc/version
then
  DOCKER_DISTRO="Ubuntu"
  DOCKER_DIR=/mnt/wsl/shared-docker
  DOCKER_SOCK="$DOCKER_DIR/docker.sock"
  export DOCKER_HOST="unix://$DOCKER_SOCK"
  if [ ! -S "$DOCKER_SOCK" ]; then
      mkdir -pm o=,ug=rwx "$DOCKER_DIR"
      chgrp docker "$DOCKER_DIR"
      /mnt/c/Windows/System32/wsl.exe -d $DOCKER_DISTRO sh -c "nohup sudo -b dockerd < /dev/null > $DOCKER_DIR/dockerd.log 2>&1"
  fi
fi


# added by Anaconda3 5.3.1 installer
# >>> conda init >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$(CONDA_REPORT_ERRORS=false '/home/'$USER'/.anaconda3/bin/conda' shell.bash hook 2> /dev/null)"
if [ $? -eq 0 ]; then
    \eval "$__conda_setup"
else
    if [ -f "/home/$USER/.anaconda3/etc/profile.d/conda.sh" ]; then
# . "/home/$USER/.anaconda3/etc/profile.d/conda.sh"  # commented out by conda initialize
        CONDA_CHANGEPS1=false conda activate base
    else
        \export PATH="/home/$USER/.anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda init <<<

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/'$USER'/.anaconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/$USER/.anaconda3/etc/profile.d/conda.sh" ]; then
        . "/home/$USER/.anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/$USER/.anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<


## nodejs
if [[ ! -d ~/.npm-global ]] ; then mkdir ~/.npm-global ; fi
export NPM_CONFIG_PREFIX=~/.npm-global
export PATH="$PATH:/home/$USER/.npm-global/bin"

## geoserver
export GEOSERVER_HOME=/usr/share/geoserver

## airflow
export PATH="$PATH:~/.local/bin"
