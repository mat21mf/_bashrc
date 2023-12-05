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

   #PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '

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
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias lt='ls -lt'
alias lr='ls -ltr'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

alias json-schema-validator="java -jar $HOME/Downloads/Linux/hpc/json-schema-validator/json-schema-validator-2.2.6-lib.jar"

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# Functions definitions.
if [ -f ~/.bash_functions ]; then
    . ~/.bash_functions
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


#### Definiciones usuario
####

#### copiar y mover
alias cp="cp --preserve=all"
alias rsync="rsync -t --progress"
alias rsync_mv="rsync --archive --remove-source-files"

#### look & feel para Java
#### /etc/environment
#### export _JAVA_OPTIONS='-Dawt.useSystemAAFontSettings=on -Dswing.aatext=true -Dswing.defaultlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel -Dswing.crossplatformlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel'

#### color less
### apt-get install --no-install-recommends source-highlight
### updatedb
### locate lesspipe.sh
export LESSOPEN="| /usr/share/source-highlight/src-hilite-lesspipe.sh %s"
export LESS=' -RS#3NM~g '

###
### Prioritarias
###

### editor
export EDITOR='vim'

### tmuxinator
### source ~/.bin/tmuxinator.bash
alias mux='tmuxinator'

### Idioma
export LANG=es_CL.UTF-8

# mappings for Ctrl-left-arrow and Ctrl-right-arrow for word moving
if [ -t 1 ] ; then
  bind '"\e[1;5C": forward-word'
  bind '"\e[1;5D": backward-word'
  bind '"\e[5C": forward-word'
  bind '"\e[5D": backward-word'
  bind '"\e\e[C": forward-word'
  bind '"\e\e[D": backward-word'
fi

### pdflatex
PDFLATEX="pdflatex --shell-escape"
export PDFLATEX
LUALATEX="lualatex --shell-escape"
export LUALATEX
### alias pdflatex='pdflatex --shell-escape'
### alias lualatex='lualatex --shell-escape'

### pdfsizeopt
alias pdfsizeopt='pdfsizeopt --use-pngout=no --use-jbig2=true --do-unify-fonts=false'

### youtube-dl
alias youtube-dl="youtube-dl --continue --restrict-filenames -o '%(upload_date)s_%(title)s.%(ext)s'"
alias yt-dlp="yt-dlp --continue --restrict-filenames -o '%(upload_date)s_%(title)s.%(ext)s'"

### ffprobe
alias ffprobe='ffprobe "$@" 2>&1'

### kubectl
alias kubectl="minikube kubectl --"

#### Color:
#### https://unix.stackexchange.com/questions/124407/what-color-codes-can-i-use-in-my-ps1-prompt
#PS1='\[\033[01;38;5;022m\]\u@\H:\[\033[01;38;5;202m\]\W\$\[\033[00m\] '
#PS1='\[\033[01;38;5;034m\]\u@\H:\[\033[01;38;5;032m\]\W\$\[\033[00m\] '
 PS1='\[\033[01;38;5;036m\]\u@\H:\[\033[01;38;5;033m\]\W\$\[\033[00m\] '

### qt usando gtk skin
### sudo apt-get install --no-install-recommends qt5-style-plugins ### gtk
export QT_QPA_PLATFORMTHEME=gtk2
### qt5 screen factor
export QT_AUTO_SCREEN_SCALE_FACTOR=0

###
### Radios
###

### - se instalo radiotray tambien
###
### alias radiouchile="mplayer http://200.89.71.21:8000/"
alias radiouchile="mplayer https://streamuchile.teslati.com/liveruch"
alias radiobiobiosantiago="mplayer https://redirector.dps.live/biobiosantiago/aac/icecast.audio"
alias radiobiobioconcepcion="mplayer https://redirector.dps.live/biobioconcepcion/aac/icecast.audio"
alias radiobiobiovalparaiso="mplayer https://redirector.dps.live/biobiovalparaiso/aac/icecast.audio"
alias radiocapital="mplayer https://playerservices.streamtheworld.com/api/livestream-redirect/RADIO_CAPITAL.mp3"
alias radiomadretierra="mplayer https://onlineradiobox.com/json/cl/salud/play?platform=web"

###
### Otras
###

### Ruta a disco toshiba
export TOBA="/media/$USER/OUDIN"
export TOBB="$TOBA/RESPALDOS"

### pup desde golang
export GOPATH=$HOME/gocode


# say
alias say='spd-say'

## added by Anaconda3 installer
source $HOME/.anaconda3/etc/profile.d/conda.sh  # commented out by conda initialize
  # export PATH="$PATH:$HOME/.anaconda3/bin"
# source ~/.anaconda3/etc/profile.d/conda.sh  # commented out by conda initialize
#$HOME/.anaconda3/bin:\

# java home
export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
# apache maven
M2_HOME='/opt/maven'

# path
# /opt/Qt5.14.2/5.14.2/gcc_64/bin:\
# $HOME/gocode/bin:\
export PATH=\
/root/.local/bin:\
$M2_HOME/bin:\
$HOME/.bin:\
/usr/local/sbin:\
/usr/sbin:\
/opt/boost:\
/opt/caffe/bin:\
/opt/opencv/bin:\
/opt/gephi/bin:\
/opt/drakon:\
/usr/local/go/bin:\
$PATH

# /opt/unity3d/Editor:\
# /opt/ibm/db2/V11.1/bin:\
# /opt/ibm/db2/V11.1/instance:\
# /usr/lib/libreoffice/program:\
# /opt/gradle/gradle-4.4/bin
# /opt/intel/intelpython2/bin:\
# /opt/intel/intelpython3/bin

# /opt/Qt5.14.2/5.14.2/gcc_64/lib:\
# $HOME/Downloads/Linux/sistema/qt_opensource/fbsenv/lib/python3.5/site-packages/PyQt5/Qt/plugins/platforms:\
export LD_LIBRARY_PATH=\
/usr/local/lib:\
/usr/lib:\
/usr/lib/x86_64-linux-gnu:\
/opt/qxmledit:\
/usr/local/lib/x86_64-linux-gnu:\
/usr/lib/libreoffice/program:\
$LD_LIBRARY_PATH

# export QT_QPA_PLATFORM_PLUGIN_PATH=\
# /usr/lib/x86_64-linux-gnu/qt5/plugins/platforms:\
# /opt/Qt5.14.2/5.14.2/gcc_64/plugins/platforms:\
# /opt/Qt5.14.2/Tools/QtCreator/lib/Qt/plugins/platforms

#/opt/intel/compilers_and_libraries_2018.0.128/linux/mkl/lib/intel64_lin:\
#/opt/intel/compilers_and_libraries_2018.0.128/linux/mkl/lib:\
#/opt/intel/compilers_and_libraries_2018/linux/lib:\
#/opt/intel/compilers_and_libraries/linux/lib:\
#/opt/intel/lib:\
#/opt/intel:\
#/opt/firefox21.x86
#$LD_LIBRARY_PATH

# setup libgtkflow
#export LD_LIBRARY_PATH=/usr/local/lib/x86_64-linux-gnu
export GI_TYPELIB_PATH=/usr/local/lib/x86_64-linux-gnu/girepository-1.0/

export DYLD_LIBRARY_PATH=\
$HOME/git.repos/caffe/build/lib:\
$HOME/git.repos/caffe/.build_release/lib

# export PYTHONHOME=\
# /opt/intel/intelpython2

export CAFFE_ROOT=\
/opt/caffe

# intel library
# source /opt/intel/compilers_and_libraries_2018.0.128/linux/bin/compilervars.sh -arch intel64 -platform linux
# source /opt/intel/compilers_and_libraries_2018.0.128/linux/mkl/bin/mklvars.sh intel64
# source /opt/intel/compilers_and_libraries_2018.0.128/linux/bin/iccvars.sh intel64

# spark
export PYTHONPATH="$SPARK_HOME/python:$SPARK_HOME/python/build:$SPARK_HOME/python/lib/py4j-0.10.9.7-src.zip:$PYTHONPATH"

# unset PYTHONPATH
# unset PYTHONPATH

# export PYTHONPATH=\
# $CAFFE_ROOT/python:\
# /opt/intel/intelpython2/lib/python2.7/site-packages:\
# $PYTHONPATH

# ### pyenv para vim 8.1
# export PATH="$HOME/.pyenv/bin:$PATH"
# eval "$(pyenv init -)"
# eval "$(pyenv virtualenv-init -)"

  # desactivar system bell
  if [ -n "$DISPLAY" ]; then
    xset b off
  fi

### LD_LIBRARY_PATH
# export LD_LIBRARY_PATH=\

### gnu make
export MAKE="make -j1"
export MAKEFLAGS='-j1'

### phantomjs nodejs
export OPENSSL_CONF=/usr/include/nodejs/openssl.cnf

# npm-global
export PATH=~/.npm-global/bin:$PATH

### spark
export SPARK_HOME=/opt/spark
export PATH=$PATH:$SPARK_HOME/bin:$SPARK_HOME/sbin
export PYSPARK_PYTHON=/usr/bin/python3

# # >>> conda initialize >>>
# # !! Contents within this block are managed by 'conda init' !!
# __conda_setup="$('$HOME/.anaconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
# if [ $? -eq 0 ]; then
#     eval "$__conda_setup"
# else
#     if [ -f "$HOME/.anaconda3/etc/profile.d/conda.sh" ]; then
#         . "$HOME/.anaconda3/etc/profile.d/conda.sh"  # commented out by conda initialize
#     else
#         export PATH="$HOME/.anaconda3/bin:$PATH"  # commented out by conda initialize
#     fi
# fi
# unset __conda_setup
# # <<< conda initialize <<<


export PATH=$HOME/.local/bin:$PATH
# Yavide alias
alias yavide="gvim --servername yavide -f -N -u $HOME/.vim/bundle/yavide/yavide/.vimrc"
# Yavide alias
alias yavide="gvim --servername yavide -f -N -u $HOME/.vim/bundle/yavide/yavide/.vimrc -u $HOME/.vim/bundle/yavide/yavide/.vimrc"
# Yavide alias
alias yavide="gvim --servername yavide -f -N -u $HOME/.vim/bundle/yavide/yavide/.vimrc -u $HOME/.vim/bundle/yavide/yavide/.vimrc -u $HOME/.vim/bundle/yavide/.vimrc"

### var entorno docker
export DOCKER_HOST=unix://$XDG_RUNTIME_DIR/docker.sock
# export DOCKER_HOST=unix://var/run/docker.sock

complete -C /usr/bin/terraform terraform

# tabtab source for electron-forge package
# uninstall by removing these lines or running `tabtab uninstall electron-forge`
[ -f /home/matqud/Downloads/Linux/vis/shiny-electron/r-shiny-electron/node_modules/tabtab/.completions/electron-forge.bash ] && . /home/matqud/Downloads/Linux/vis/shiny-electron/r-shiny-electron/node_modules/tabtab/.completions/electron-forge.bash
# Run something, muting output or redirecting it to the debug stream
# depending on the value of _ARC_DEBUG.
# If ARGCOMPLETE_USE_TEMPFILES is set, use tempfiles for IPC.
__python_argcomplete_run() {
    if [[ -z "${ARGCOMPLETE_USE_TEMPFILES-}" ]]; then
        __python_argcomplete_run_inner "$@"
        return
    fi
    local tmpfile="$(mktemp)"
    _ARGCOMPLETE_STDOUT_FILENAME="$tmpfile" __python_argcomplete_run_inner "$@"
    local code=$?
    cat "$tmpfile"
    rm "$tmpfile"
    return $code
}

__python_argcomplete_run_inner() {
    if [[ -z "${_ARC_DEBUG-}" ]]; then
        "$@" 8>&1 9>&2 1>/dev/null 2>&1
    else
        "$@" 8>&1 9>&2 1>&9 2>&1
    fi
}

_python_argcomplete() {
    local IFS=$'\013'
    local SUPPRESS_SPACE=0
    if compopt +o nospace 2> /dev/null; then
        SUPPRESS_SPACE=1
    fi
    COMPREPLY=( $(IFS="$IFS" \
                  COMP_LINE="$COMP_LINE" \
                  COMP_POINT="$COMP_POINT" \
                  COMP_TYPE="$COMP_TYPE" \
                  _ARGCOMPLETE_COMP_WORDBREAKS="$COMP_WORDBREAKS" \
                  _ARGCOMPLETE=1 \
                  _ARGCOMPLETE_SUPPRESS_SPACE=$SUPPRESS_SPACE \
                  __python_argcomplete_run "$1") )
    if [[ $? != 0 ]]; then
        unset COMPREPLY
    elif [[ $SUPPRESS_SPACE == 1 ]] && [[ "${COMPREPLY-}" =~ [=/:]$ ]]; then
        compopt -o nospace
    fi
}
complete -o nospace -o default -o bashdefault -F _python_argcomplete airflow

##THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
#export SDKMAN_DIR="$HOME/.sdkman"
#[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
#. "$HOME/.cargo/env"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

