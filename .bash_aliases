# .bash_aliases

### yt-dlp youtube-dl
alias yt-dlp="yt-dlp --continue --restrict-filenames -o '%(upload_date)s_%(title)s.%(ext)s'"

### tmuxinator
alias mux=tmuxinator

#### copiar y mover
alias cp="cp --preserve=all"
alias rsync="rsync -t --progress"
alias rsync_mv="rsync --archive --remove-source-files"

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

# say
alias say='spd-say'

# Yavide alias
alias yavide="gvim --servername yavide -f -N -u $HOME/.vim/bundle/yavide/yavide/.vimrc"
# Yavide alias
alias yavide="gvim --servername yavide -f -N -u $HOME/.vim/bundle/yavide/yavide/.vimrc -u $HOME/.vim/bundle/yavide/yavide/.vimrc"
# Yavide alias
alias yavide="gvim --servername yavide -f -N -u $HOME/.vim/bundle/yavide/yavide/.vimrc -u $HOME/.vim/bundle/yavide/yavide/.vimrc -u $HOME/.vim/bundle/yavide/.vimrc"

alias json-schema-validator="java -jar $HOME/Downloads/Linux/hpc/json-schema-validator/json-schema-validator-2.2.6-lib.jar"

