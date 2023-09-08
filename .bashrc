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

### rmarkdown + shell-escape
### Revisar función script $HOME/.bin/Render.R
### Evitar crear siempre mismo código para crear pdf usando rmarkdown
function Render ()
{
  if [[ "${2}" == "" ]] ; then
    R --slave --args "${1}" < $HOME/.bin/Render.R
  else
    R --slave --args "${1}" "${2}" < $HOME/.bin/Render.R
  fi
}
export -f Render

function RenderHtml ()
{
  if [[ "${2}" == "" ]] ; then
    R --slave --args "${1}" < $HOME/.bin/RenderHtml.R
  else
    R --slave --args "${1}" "${2}" < $HOME/.bin/RenderHtml.R
  fi
}
export -f RenderHtml

function RenderDocx ()
{
  if [[ "${2}" == "" ]] ; then
    R --slave --args "${1}" < $HOME/.bin/RenderDocx.R
  else
    R --slave --args "${1}" "${2}" < $HOME/.bin/RenderDocx.R
  fi
}
export -f RenderDocx

function Purl ()
{
  if [[ -f "${2}" ]] ; then rm -rf "${2}" ; fi
  R --no-init-file --slave --args "${1}" "${2}" "${3}" < $HOME/.bin/Purl.R
}
export -f Purl

function RunShiny () {
  strinp="$( realpath -s ${1} )"
  strout="$(echo ${strfle} | sed -r 's/(.*)\/(.*)\.(.*)/\2\.R/')"
  Purl ${strinp} ${strout}
  R --slave --args "${strout}" < $HOME/.bin/RunShiny.R
}
export -f RunShiny

function rpubsUpload ()
{
  R --no-init-file --slave --args "${1}" "${2}" < $HOME/.bin/rpubsUpload.R
}
export -f rpubsUpload

function ComaAArroba ()
{
  R --no-init-file --slave --args "${1}" "${2}" "${3}" < $HOME/.bin/CsvComaAArroba.R
}
export -f ComaAArroba

function EspacioAComa ()
{
  R --no-init-file --slave --args "${1}" "${2}" "${3}" < $HOME/.bin/CsvEspacioAComa.R
}
export -f EspacioAComa

function SavARds ()
{
  R --no-init-file --slave --args "${1}" "${2}" "${3}" < $HOME/.bin/SavARds.R
}
export -f SavARds

function MdbARds ()
{
  R --no-init-file --slave --args "${1}" "${2}" "${3}" < $HOME/.bin/MdbARds.R
}
export -f MdbARds

function CsvARds ()
{
  R --no-init-file --slave --args "${1}" "${2}" "${3}" < $HOME/.bin/CsvARds.R
}
export -f CsvARds

function CsvAXlsx ()
{
  R --no-init-file --slave --args "${1}" "${2}" "${3}" < $HOME/.bin/CsvAXlsx.R
}
export -f CsvAXlsx

function XlsxAParquet ()
{
  if [[ "${3}" == "" ]] ; then
    R --vanilla --slave --args "${1}" "${2}" < $HOME/.bin/XlsxAParquet.R
  else
    R --vanilla --slave --args "${1}" "${2}" "${3}" < $HOME/.bin/XlsxAParquet.R
  fi
}
export -f XlsxAParquet

function ParquetAXlsx ()
{
  if [[ "${3}" == "" ]] ; then
    R --vanilla --slave --args "${1}" "${2}" < $HOME/.bin/ParquetAXlsx.R
  else
    R --vanilla --slave --args "${1}" "${2}" "${3}" < $HOME/.bin/ParquetAXlsx.R
  fi
}
export -f ParquetAXlsx

function ParquetASav ()
{
    R --vanilla --slave --args "${1}" "${2}" < $HOME/.bin/ParquetASav.R
}
export -f ParquetASav

function XlsxGetSheets ()
{
  R --vanilla --slave --args "${1}" < $HOME/.bin/XlsxGetSheets.R
}
export -f XlsxGetSheets

function getFeatherColnames ()
{
  R --vanilla --slave --args "${1}" < $HOME/.bin/getFeatherColnames.R
}
export -f getFeatherColnames

function GetDims ()
{
  if [[ "${2}" == "" ]] ; then
    R --vanilla --slave --args "${1}" < $HOME/.bin/GetDims.R
  else
    R --vanilla --slave --args "${1}" "${2}" < $HOME/.bin/GetDims.R
  fi
}
export -f GetDims

function GetColnames ()
{
  R --vanilla --slave --args "${1}" < $HOME/.bin/GetColnames.R
}
export -f GetColnames

function CsvAParquet ()
{
  R --vanilla --slave --args "${1}" "${2}" "${3}" < $HOME/.bin/CsvAParquet.R
}
export -f CsvAParquet

function TabAXlsx ()
{
  R --no-init-file --slave --args "${1}" "${2}" "${3}" < $HOME/.bin/TabAXlsx.R
}
export -f TabAXlsx

function TabARds ()
{
  R --no-init-file --slave --args "${1}" "${2}" "${3}" < $HOME/.bin/TabARds.R
}
export -f TabARds

function editarOpcionesBloques ()
{
  if [[ ${2} == "" ]] ; then
    grep -i '^```{.*}$' ${1} \
      | sed -r 's/(```\{.*), .*(\})/  sil g\/\\(\1\\)\\(\2\\)\/ s\/\/\\1, cache=TRUE\\2\//'
  else
    grep -i '^```{.*}$' ${1} \
      | sed -r 's/(```\{.*), .*(\})/  sil g\/\\(\1\\)\\(\2\\)\/ s\/\/\\1, cache=TRUE\\2\//' \
      > ${2}
  fi
}
export -f editarOpcionesBloques

function versionesPip ()
{
  PACKAGE_JSON_URL="https://pypi.org/pypi/${1}/json"
  curl -L -s "$PACKAGE_JSON_URL" | jq -r '.releases | keys | .[]' | sort -V
}
export -f versionesPip

function acortarEnlace ()
{
  curl -s http://tinyurl.com/api-create.php?url="${1}" \
  # | grep -m1 -oP '(?<=data-clipboard-text=").+(?=">)'
}
export -f acortarEnlace

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

#### Funciones definidas por usuario
####

  function CrearHistorialR ()
  {
    if [[ ! -f .Rhistory ]] ; then
      echo ""                               >  .Rhistory
      echo "  ### Historial autogenerado R" >> .Rhistory
      echo "  system(\"echo \$TMUX_PANE\")" >> .Rhistory
      echo "  save.image()"                 >> .Rhistory
      echo "  load()"                       >> .Rhistory
      echo "  ls()"                         >> .Rhistory
      echo "  savehistory()"                >> .Rhistory
    else
      echo ""                               >> .Rhistory
      echo "  ### Historial autogenerado R" >> .Rhistory
      echo "  system(\"echo \$TMUX_PANE\")" >> .Rhistory
      echo "  save.image()"                 >> .Rhistory
      echo "  load()"                       >> .Rhistory
      echo "  ls()"                         >> .Rhistory
      echo "  savehistory()"                >> .Rhistory
    fi
  }
  export -f CrearHistorialR

  function TexTabHead () {
    echo \\begin{table}[ht]
    echo \\begin{center}
    echo \\input{"${3}"}
    echo \\caption{"${1}"}
    echo \\label{"${2}"}
    echo \\end{center}
    echo \\end{table}
  }
  export -f TexTabHead

  #### Ejemplos
  # TexTabHead "Número de imágenes de la base BreakHis original."       "reftabdistr"      "tabdistr" > ${tablatdirinp}headtabdistr.tex
  # TexTabHead "Número de imágenes según tipo de aumento."              "reftabaugmt"      "tabaugmt" > ${tablatdirinp}headtabaugmt.tex
  # TexTabHead "Tipo de aumento de imágenes."                           "reftablente"      "tablente" > ${tablatdirinp}headtablente.tex
  # TexTabHead "Número de imágenes según tipo de aumento y malignidad." "reftabtargt"      "tabtargt" > ${tablatdirinp}headtabtargt.tex
  # TexTabHead "Muestreo estratificado para imágenes de aumento 400X."  "reftabstrmp"      "tabstrmp" > ${tablatdirinp}headtabstrmp.tex

  function TexGraphInput () {
    echo \\fbox{\\includegraphics["${2}"]{"${1}"}}
  }
  export -f TexGraphInput

  function TexGraphHead () {
    echo \\begin{figure}[ht]
    echo \\begin{center}
    echo \\input{"${3}"}
    echo \\caption{"${1}"}
    echo \\label{"${2}"}
    echo \\end{center}
    echo \\end{figure}
  }
  export -f TexGraphHead

  function extraer () {
        if [ -f $1 ] ; then
          case $1 in
            *.tar.bz2)   tar xjf $1     ;;
            *.tar.gz)    tar xzf $1     ;;
            *.bz2)       bunzip2 $1     ;;
            *.rar)       unrar e $1     ;;
            *.gz)        gunzip $1      ;;
            *.tar)       tar xf $1      ;;
            *.tbz2)      tar xjf $1     ;;
            *.tgz)       tar xzf $1     ;;
            *.zip)       unzip $1       ;;
            *.Z)         uncompress $1  ;;
            *.7z)        7z x $1        ;;
            *)     echo "'$1' cannot be extracted via extract()" ;;
             esac
         else
             echo "'$1' is not a valid file"
         fi
  }
  export -f extraer

  function jrnlimport () {
    echo `stat -c '%.19z ' "${1}" `cat "${1}" | jrnl
  }
  export -f jrnlimport

  function dirsize () {
      find "${@-.}" -maxdepth 1 -type d -exec du -hs '{}' \; 2>/dev/null
  }
  export -f dirsize

  function du_sorted () {
      local ds="${@-.}"
      paste -d '#' <(du $ds) <(du -h $ds) | sort -n -k1,7 | cut -d '#' -f 2
  }
  export -f du_sorted

  function LeerEpub () {
    /usr/bin/python2.7 \
      $HOME/git.repos/epub/epub.py "${1}"
  }
  export -f LeerEpub

  function RespaldarEnDestino () {
    if [[ "${3}" == "" ]] ; then
      echo
      echo "Respaldando con conexión desde ${1}"
      echo "hacia ${2}"
      echo
      rsync -rltvz -O --progress "${1}" "${2}"
    else
      echo
      echo "Respaldando con conexión desde ${1}"
      echo "hacia ${2}"
      echo "con exclusion ${3}"
      echo
      rsync -rltvz -O --progress --exclude-from="${3}" "${1}" "${2}"
    fi
  }
  export -f RespaldarEnDestino

  function RespaldarEnDestinoTest () {
    if [[ "${3}" == "" ]] ; then
      echo
      echo "Respaldando con conexión desde ${1}"
      echo "hacia ${2}"
      echo
      rsync -rltvz -O --update --dry-run --progress "${1}" "${2}"
    else
      echo
      echo "Respaldando con conexión desde ${1}"
      echo "hacia ${2}"
      echo "con exclusion ${3}"
      echo
      rsync -rltvz -O --update --dry-run --progress --exclude-from="${3}" "${1}" "${2}"
    fi
  }
  export -f RespaldarEnDestinoTest

  function AbrirConexionLocal () {
    #### Formato de destino
    #### desdir="user@ip"
    #### Revisar el handle en ctl no es un archivo, es un socket?
    if [[ ! -d $HOME/.ssh/ctl/ ]] ; then mkdir $HOME/.ssh/ctl/ ; fi
    if [[ -f "$HOME/.ssh/ctl/%L-%r@%h:%p" ]] ; then
      echo
      echo "Ya existe conexión con ${1}"
      echo
    else
      echo
      echo "Abriendo conexión con ${1}"
      echo
      ssh -nNf -o ControlMaster=yes -o ControlPath="$HOME/.ssh/ctl/%L-%r@%h:%p" "${1}"
    fi
  }
  export -f AbrirConexionLocal

  ###
  ### Mapear puertos remotos
  ###
  ### - Esta forma el primer puerto es el local y mapeado
  ### - Hay que terminar esta forma con ctrl-c
  ###
  ### ssh matbian@192.168.1.66 -L localhost:8081:localhost:8080 -N
  ### ssh matbian@192.168.1.66 -L localhost:8787:localhost:8787 -N
  ###
  ### - Esta forma el segundo puerto es el local y mapeado
  ### - No tengo claro como funciona bien esta forma aun
  ###
  ### ssh matbian@192.168.1.66 -R 8787:localhost:8788
  ### ssh matbian@192.168.1.66 -R 8080:localhost:8081
  ###

  function RespaldarEnRed () {
    #### Formato de destino
    #### inpdir="ruta_origen"
    #### outdir="user@ip:ruta_destino"
    if [[ "${3}" == "" ]] ; then
      echo
      echo "Respaldando con conexión desde ${1}"
      echo "hacia ${2}"
      echo
      rsync -e "ssh -o 'ControlPath=$HOME/.ssh/ctl/%L-%r@%h:%p'" -rltvz -O --update --progress "${1}" "${2}"
    else
      echo
      echo "Respaldando con conexión desde ${1}"
      echo "hacia ${2}"
      echo "con exclusion ${3}"
      echo
      rsync -e "ssh -o 'ControlPath=$HOME/.ssh/ctl/%L-%r@%h:%p'" -rltvz -O --update --progress --exclude-from="${3}" "${1}" "${2}"
    fi
  }
  export -f RespaldarEnRed

  function RespaldarEnRedTest () {
    #### Formato de destino
    #### inpdir="ruta_origen"
    #### outdir="user@ip:ruta_destino"
    if [[ "${3}" == "" ]] ; then
      echo
      echo "Respaldando con conexión desde ${1}"
      echo "hacia ${2}"
      echo
      rsync -e "ssh -o 'ControlPath=$HOME/.ssh/ctl/%L-%r@%h:%p'" -rltvz -O --dry-run --update --progress "${1}" "${2}"
    else
      echo
      echo "Respaldando con conexión desde ${1}"
      echo "hacia ${2}"
      echo "con exclusion ${3}"
      echo
      rsync -e "ssh -o 'ControlPath=$HOME/.ssh/ctl/%L-%r@%h:%p'" -rltvz -O --dry-run --update --progress --exclude-from="${3}" "${1}" "${2}"
    fi
  }
  export -f RespaldarEnRedTest

  function RenombrarEspacios () {
    find "${1}" -maxdepth 1 -type f | \
      grep -e ' ' -e ')' -e '(' -e '%20' -e '%28' -e '%29' -e '%2C' -e ':' | \
      sed -r 's/(.*)/mv "\1"\t\1/
              :a
              s/\t(.*) /\t\1_/g
              s/\t(.*)\)/\t\1_/g
              s/\t(.*)\(/\t\1_/g
              s/\t(.*)%20/\t\1_/g
              s/\t(.*)%28/\t\1_/g
              s/\t(.*)%29/\t\1_/g
              s/\t(.*)%2C/\t\1_/g
              s/\t(.*)\&/\t\1_/g
              s|\t(.*):|\t\1_|g
              ta' | \
      bash
  }
  export -f RenombrarEspacios

  function PostRenombrar () {
    find "${1}" -maxdepth 1 -type f -name '*%2C*' | \
      sed -r 's/(.*)/mv \1\t\1/
              :a
              s/\t(.*)%20/\t\1_/g
              s/\t(.*)%28/\t\1_/g
              s/\t(.*)%29/\t\1_/g
              s/\t(.*)%2C/\t\1_/g
              ta' | \
      bash
  }
  export -f PostRenombrar

  function ExportarXlsCsv () {
    python3 $HOME/.bin/pyxlsx2csv.py "${1}" "${2}" "${3}"
  }
  export -f ExportarXlsCsv

  function PaginasExcel () {
    strfle=$(echo "${1}" | sed -r 's/(.*)\.(.*)/\1/')
    strext=$(echo "${1}" | sed -r 's/(.*)\.(.*)/\2/')
    if [[ "${strext}" == "xls" ]] ; then
    xls2csv -s 0 "${1}" | \
      awk '/-{8} [0-9] - /' | \
      grep -i --color '\-\{8\} [0-9] - '
    fi
    if [[ "${strext}" == "xlsx" ]] ; then
    xlsx2csv -s 0 "${1}" | \
      awk '/-{8} [0-9] - /' | \
      grep -i --color '\-\{8\} [0-9] - '
    fi
  }
  export -f PaginasExcel

  function RevisarGmail () {
    if [[ "${1}" == 1 ]] ; then
      mailacc="matias.rebolledo@gmail.com"
      curl -u "${mailacc}" --silent "https://mail.google.com/mail/feed/atom" | \
      tr -d '\n' | \
      awk -F '<entry>' '{for (i=2; i<=NF; i++) {print $i}}' | \
      sed -n "s/<title>\(.*\)<\/title.*<issued>\(.*\)<\/issued.*name>\(.*\)<\/name>.*/\2 - \3 - \1/p"
    fi
    if [[ "${1}" == 2 ]] ; then
      mailacc="mf.matias@gmail.com"
      curl -u "${mailacc}" --silent "https://mail.google.com/mail/feed/atom" | \
      tr -d '\n' | \
      awk -F '<entry>' '{for (i=2; i<=NF; i++) {print $i}}' | \
      sed -n "s/<title>\(.*\)<\/title.*<issued>\(.*\)<\/issued.*name>\(.*\)<\/name>.*/\2 - \3 - \1/p"
    fi
  }
  export -f RevisarGmail

  function CorregirBibLlave () {
    grep -H -i --color '@.*:' "${1}" | \
      sed -r 's/(.*):(.*):(.*)/sed -i -r '\''s\/\2:\3\/\2\3\/'\'' \1/
              s/\{/\\\{/g' | \
      bash
    grep -H -i --color '@' "${1}" | \
      sed -r 's/(.*)\{(.*),/\\cite\\\{\2\\\}/'
  }
  export -f CorregirBibLlave

  function OptimizarPdf () {
    gs -sDEVICE=pdfwrite         \
       -dCompatibilityLevel=1.4  \
       -dPrinted=false           \
       -dPDFSETTINGS=/printer    \
       -dEmbedAllFonts=true      \
       -dSubsetFonts=true        \
       -dFastWebView=true        \
       -dNOPAUSE -dQUIET -dBATCH \
       -sOutputFile="${2}"       \
        "${1}"
  }
  export -f OptimizarPdf

  function ImprimirHtmlToPdf ()
  {
    wkhtmltopdf                    \
      --disable-smart-shrinking    \
      --lowquality                 \
      --disable-javascript         \
      --load-error-handling ignore \
      --enable-external-links      \
      --enable-internal-links      \
      --page-size Letter           \
      "${1}" "${2}"
  }
  ##  --zoom 1.05                  \
  export -f ImprimirHtmlToPdf

  ### Falta que reciba stdin
  ### declare -i i=${1:-$(</dev/stdin)};
  function JsonAColumnas () {
    cat "${1}" \
      | jq -s -r '(map(keys) | add | unique) as $cols | map(. as $row | $cols | map($row[.])) as $rows | $cols, $rows[] | @tsv'
  }
  export -f JsonAColumnas

  function FlattenAColumnas () {
    jqg '.' "${1}" \
      | jq -r -s '(map(keys) | add | unique) as $cols | map(. as $row | $cols | map($row[.])) as $rows | $cols, $rows[] | @tsv'
  }
  export -f FlattenAColumnas

  function ContarDuplicadosArroba () {
    cat "${1}" \
      | sort | uniq -c \
      | sed -r 's/^ +//g' \
      | gawk -F' ' '{if($1>1) print $0}' \
      | wc -l \
      | sed -r 's/ //g'
  }
  export -f ContarDuplicadosArroba

  function ListarCabecerasTab () {
    gawk -F'\t' 'NR==1 {for(i=1;i<=NF;i++) printf "%s:%s:%s\n", FILENAME, $i, i}' "${1}"
  }
  export -f ListarCabecerasTab

  function ListarCabecerasPipe () {
    gawk -F'|' 'NR==1 {for(i=1;i<=NF;i++) printf "%s:%s:%s\n", FILENAME, $i, i}' "${1}"
  }
  export -f ListarCabecerasPipe

  function ListarCabecerasComa () {
    gawk -F',' 'NR==1 {for(i=1;i<=NF;i++) printf "%s:%s:%s\n", FILENAME, $i, i}' "${1}"
  }
  export -f ListarCabecerasComa

  function ListarCabecerasArroba () {
    if [[ ${2} == "" ]] ; then
      gawk -F'@' 'NR==1 {for(i=1;i<=NF;i++) printf "%s:%s:%s:%s:%s\n", FILENAME, $i, i, "fila", "1"}' "${1}"
    else
      gawk -F'@' 'NR=='"${2}"' {for(i=1;i<=NF;i++) printf "%s:%s:%s:%s:%s\n", FILENAME, $i, i, "fila", '"${2}"'}' "${1}"
    fi
  }
  export -f ListarCabecerasArroba

  function ListarFaltantesComa () {
    ListarCabecerasComa "${1}" \
      | gawk -F: '{print "gawk -F'\'','\'' '\''NR>1 {if($"$3"==\"'"${2}"'\") {counter++}} END {print FILENAME,\""$2"\",\""$3"\",counter}'\'' OFS='\'':'\'' "$1}' \
      | bash \
      | sed -r 's/(.*):(.*):(.*):(.*)/\1:\2:\3:vacios:\4/' \
      | gawk -F':' '{if($5=="") {print $1,$2,$3,$4,"0"}
                     else       {print $1,$2,$3,$4,$5}}' OFS=':'
  }
  export -f ListarFaltantesComa

  function ListarFaltantesArroba () {
    ListarCabecerasArroba "${1}" \
      | gawk -F: '{print "gawk -F'\''@'\'' '\''NR>1 {if($"$3"==\"'"${2}"'\") {counter++}} END {print FILENAME,\""$2"\",\""$3"\",counter}'\'' OFS='\'':'\'' "$1}' \
      | bash \
      | sed -r 's/(.*):(.*):(.*):(.*)/\1:\2:\3:vacios:\4/' \
      | gawk -F':' '{if($5=="") {print $1,$2,$3,$4,"0"}
                     else       {print $1,$2,$3,$4,$5}}' OFS=':'
  }
  export -f ListarFaltantesArroba

  function CrearArchivoRuta ()
  {
    pwd \
      | sed -r 's/(.*)/declare -gx srcdir=\"\1\"/' \
      | sed -r 's/\/home\/[a-z]*\//\$HOME\//' > "${1}"
  }
  export -f CrearArchivoRuta

  function TransponerArchivoComa ()
  {
    vim --not-a-term "${1}" -c "sil g/,/s//\t/g" -c "sil %TransposeTab" -c "sil g/\t/s//,/g" -c "sil wq"
  }
  export -f TransponerArchivoComa

  declare -gx FiltroValoresUnicosPipe="
  sed -r 's/(.*):(.*):(.*)/( echo -n \"\\1:\\2:\\3:unicos:\" ; gawk -F'\''|'\'' '\''NR>1 {count[$\\3]++} END {for (obs in count) print count[obs], obs}'\'' \\1 | wc -l )/' | bash
  "
  declare -gx FiltroValoresUnicosComa="
  sed -r 's/(.*):(.*):(.*)/( echo -n \"\\1:\\2:\\3:unicos:\" ; gawk -F'\'','\'' '\''NR>1 {count[$\\3]++} END {for (obs in count) print count[obs], obs}'\'' \\1 | wc -l )/' | bash
  "
  declare -gx FiltroValoresUnicosArroba="
  sed -r 's/(.*):(.*):(.*)/( echo -n \"\\1:\\2:\\3:unicos:\" ; gawk -F'\''@'\'' '\''NR>1 {count[$\\3]++} END {for (obs in count) print count[obs], obs}'\'' \\1 | wc -l )/' | bash
  "
  function ListarSumaValoresUnicosPipe ()
  {
      ListarCabecerasPipe "${1}" \
        | bash -c "${FiltroValoresUnicosPipe}"
  }
  export -f ListarSumaValoresUnicosPipe
  function ListarSumaValoresUnicosComa ()
  {
      ListarCabecerasComa "${1}" \
        | bash -c "${FiltroValoresUnicosComa}"
  }
  export -f ListarSumaValoresUnicosComa
  function ListarSumaValoresUnicosArroba ()
  {
      ListarCabecerasArroba "${1}" \
        | bash -c "${FiltroValoresUnicosArroba}"
  }
  export -f ListarSumaValoresUnicosArroba

  function ListarColumnasUnicasArroba ()
  {
    gawk -F'@' '{print FILENAME, NF}' ${1} | sort | uniq -c \
      | gawk '{printf "%s:%s:%s:%s:%s\n", $2, "filas", $1, "columnas", $3}'
  }
  export -f ListarColumnasUnicasArroba

  function ListarColumnasUnicasComa ()
  {
    gawk -F',' '{print FILENAME, NF}' ${1} | sort | uniq -c \
      | gawk '{printf "%s:%s:%s:%s:%s\n", $2, "filas", $1, "columnas", $3}'
  }
  export -f ListarColumnasUnicasComa

  function ListarColumnasUnicasTab ()
  {
    gawk -F'\t' '{print FILENAME, NF}' ${1} | sort | uniq -c \
      | gawk '{printf "%s:%s:%s:%s:%s\n", $2, "filas", $1, "columnas", $3}'
  }
  export -f ListarColumnasUnicasTab

  function UnirColumnasAWKComa ()
  {
    gawk 'BEGIN{FS=OFS=","} NR==FNR {a[$1]=$0;next} {print $0,a[$1],a[$2]}' "${1}" "${2}"
  }
  export -f UnirColumnasAWKComa

  function Rfind ()
  {
    if [[ "${1}" == "" ]] ; then
      find -type f | grep -i --color '\.R'
    else
      find "${1}" -type f | grep -i --color '\.R'
    fi
  }
  export -f Rfind

  function ExcluirArchivosR ()
  {
    if [[ "${1}" == "" ]] ; then
    find -type f \
      | sort \
      | grep -v -i '\.Rd$\|\.R$\|\/CITATION$\|\/COPYING$\|\/DESCRIPTION$\|\/LICENSE$\|\/README$\|\/NEWS$\|\/INDEX$\|\/AnIndex$\|\.md$' \
      | grep -v -i '\.rds$\|\.rdb$\|\.rdx$\|\.html$\|\.css$\|\.tex$\|\.feather$\|\.Rmd$\|\.r$\|\.png$\|\.bib$\|\.git\/\|\.rd$\|\.save$' \
      | grep -v -i '\.po$\|\.pot$\|\.mo$\|\.rda$\|\.tab$\|\.o$\|\.so$\|\.jpg$\|\.Rout$\|\.log$\|\.RData$\|\.pdf$'
    else
    find "${1}" -type f \
      | sort \
      | grep -v -i '\.Rd$\|\.R$\|\/CITATION$\|\/COPYING$\|\/DESCRIPTION$\|\/LICENSE$\|\/README$\|\/NEWS$\|\/INDEX$\|\/AnIndex$\|\.md$' \
      | grep -v -i '\.rds$\|\.rdb$\|\.rdx$\|\.html$\|\.css$\|\.tex$\|\.feather$\|\.Rmd$\|\.r$\|\.png$\|\.bib$\|\.git\/\|\.rd$\|\.save$' \
      | grep -v -i '\.po$\|\.pot$\|\.mo$\|\.rda$\|\.tab$\|\.o$\|\.so$\|\.jpg$\|\.Rout$\|\.log$\|\.RData$\|\.pdf$'
    fi
  }
  export -f ExcluirArchivosR

  function TrackersEdit ()
  {
  ### agregar trackers adicionales
  while IFS= read -r lin ; do
    bash -c "transmission-edit -a \"${lin}\" ${1}"
  done < $HOME/Downloads/Linux/trackers/csv/trackerslist.txt
  }
  export -f TrackersEdit

  function emailConvert ()
  {
    java -jar ~/.bin/emailconverter-2.5.3-all.jar "${1}"
  }
  export -f emailConvert

# function MagnetToTorrent ()
# {
#   ### #################################
#   ### Reemplazado por transmission-edit
#   ### #################################
#   ### opcion 1
#  #python $HOME/.bin/Magnet2Torrent.py -m "${1}" -o "${2}"
#   ### opcion 2
#  #[[ "$1" =~ xt=urn:btih:([^&/]+) ]] || exit;
#  #echo "d10:magnet-uri${#1}:${1}e" > "meta-${BASH_REMATCH[1]}.torrent"
#   ### opcion 3
#  #aria2c -d "${1}" --bt-metadata-only=true --bt-save-metadata=true --listen-port=6881 "${2}"
# }
# export -f MagnetToTorrent

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

