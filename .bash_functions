###
### Funciones definidas por usuario
###

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

  function XlsxARds ()
  {
    if [[ "${3}" == "" ]] ; then
      R --vanilla --slave --args "${1}" "${2}" < $HOME/.bin/XlsxARds.R
    else
      R --vanilla --slave --args "${1}" "${2}" "${3}" < $HOME/.bin/XlsxARds.R
    fi
  }
  export -f XlsxARds

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

  function RenombrarEspaciosPreview() {
    local dir="${1:-.}"
    find "$dir" -maxdepth 1 -type f -print0 | while IFS= read -r -d '' file; do
      local base="$(basename "$file")"
      local dirn="$(dirname "$file")"
      local newname="$base"
      newname="$(echo "$newname" | sed 's/[[:space:]]\+/_/g')"
      newname="$(echo "$newname" | iconv -f UTF-8 -t ASCII//TRANSLIT 2>/dev/null)"
      newname="$(echo "$newname" | sed 's/[^A-Za-z0-9._-]/_/g')"
      newname="$(printf '%s' "$newname" | tr '\n\r' '_')"
      if [[ "$newname" != "$base" ]]; then
        echo "mv -- '$file' '$dirn/$newname'"
      fi
    done
  }
  export -f RenombrarEspaciosPreview

  function RenombrarEspacios() {
    local dir="${1:-.}"

    find "$dir" -maxdepth 1 -type f -print0 | while IFS= read -r -d '' file; do
      # Extract basename and directory
      local base="$(basename "$file")"
      local dirn="$(dirname "$file")"

      # Create local variable newname
      local newname="$base"

      # Replace literal newlines and carriage returns with underscores first
      newname="$(printf '%s' "$newname" | tr '\n\r' '_')"

      # Replace problematic characters with underscores
      newname="$(echo "$newname" | sed \
        -e 's/[[:space:]]\+/_/g' \
        -e 's/[()]/_/g' \
        -e 's/%20/_/g' \
        -e 's/%28/_/g' \
        -e 's/%29/_/g' \
        -e 's/%2C/_/g' \
        -e 's/&/_/g' \
        -e 's/:/_/g' \
        -e "s/'/_/g" \
        -e 's/"/_/g' \
        -e 's/,/_/g' \
        -e 's/__*/_/g' \
      )"

      # Remove accents
      newname="$(echo "$newname" | iconv -f UTF-8 -t ASCII//TRANSLIT 2>/dev/null)"

      # Replace any remaining non-ASCII characters
      newname="$(echo "$newname" | sed 's/[^A-Za-z0-9._-]/_/g')"

      # Collapse multiple underscores
      newname="$(echo "$newname" | sed 's/__*/_/g')"

      # Trim leading/trailing underscores
      newname="$(echo "$newname" | sed 's/^_//; s/_$//')"

      # Rename if the filename changed
      if [[ "$newname" != "$base" ]]; then
        echo "Renombrando: '$base' → '$newname'"
        mv -n -- "$file" "$dirn/$newname"
      fi
    done
  }
  export -f RenombrarEspacios

  # Same spirit as RenombrarEspacios (sanitize names in a dir), but stamps
  # every file in the dir with its own mtime instead, via rename_timestamp.py.
  # Copies by default (matches rename_timestamp.py's own default - source
  # files are left untouched); pass --move to rename in place instead.
  # Usage: RenombrarTimestampsPreview [dir] [--move]
  function RenombrarTimestampsPreview() {
    local dir="."
    local move=""
    for arg in "$@"; do
      case "$arg" in
        --move) move="--move" ;;
        *) dir="$arg" ;;
      esac
    done
    find "$dir" -maxdepth 1 -type f -print0 | while IFS= read -r -d '' file; do
      python3 "$HOME/.local/bin/rename_timestamp.py" "$file" $move --dry-run
    done
  }
  export -f RenombrarTimestampsPreview

  # Copies by default (matches rename_timestamp.py's own default - source
  # files are left untouched); pass --move to rename in place instead.
  # Safe to re-run: already-correctly-stamped files are reported and left
  # untouched, nothing stacks.
  # Usage: RenombrarTimestamps [dir] [--move]
  function RenombrarTimestamps() {
    local dir="."
    local move=""
    for arg in "$@"; do
      case "$arg" in
        --move) move="--move" ;;
        *) dir="$arg" ;;
      esac
    done
    find "$dir" -maxdepth 1 -type f -print0 | while IFS= read -r -d '' file; do
      python3 "$HOME/.local/bin/rename_timestamp.py" "$file" $move
    done
  }
  export -f RenombrarTimestamps

  # After a `git pull`/commit in this repo, offer to apply the files that
  # changed recently to where they're actually deployed on this machine
  # (default $HOME) - .bashrc -> $HOME/.bashrc, .local/bin/foo -> $HOME/.local/bin/foo,
  # following the repo's own layout as the mapping. Run from inside the repo.
  function SincronizarDespliegue() {
    python3 "$HOME/.local/bin/deploy_sync.py" "$@"
  }
  export -f SincronizarDespliegue

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

  function sort_json_values () {
    jq -M '
      with_entries(
        .value |= (
          # Only operate on the component object (ifs, lpjg, ...)
          if type == "object" then
            with_entries(
              .value |= (if type == "array" then sort else . end)
            )
          else
            .
          end
        )
      )
    ' ${1}
  }
  export -f sort_json_values

  function path_variable_compact () {
    jq -c 'paths(scalars) as $p | select(getpath($p[:-1]) | type == "array") | ($p[:-1] + [getpath($p)])' ${1}
  }
  export -f path_variable_compact

  function path_variable_duplicates_per_component () {
    jq -M '
      [
        paths(scalars) as $p
        | select(getpath($p[:-1]) | type == "array")
        | {component: $p[0], table: $p[1], var: getpath($p)}
      ]
      | group_by(.component)
      | map({
          component: .[0].component,
          duplicates:
            (group_by(.var)
             | map(select(length > 1))
             | map({var: .[0].var, tables: map(.table)}))
          })
      | map(select(.duplicates | length > 0))
    ' "${1}"
  }
  export -f path_variable_duplicates_per_component

  function vdiff_entities_varlist () {
    local f1 f2
    f1=$(mktemp)
    f2=$(mktemp)
    sort_json_values ${1} | jq -M '.' > "$f1"
    sort_json_values ${2} | jq -M '.' > "$f2"
    vimdiff "$f1" "$f2"
    rm "$f1" "$f2"
  }
  export -f vdiff_entities_varlist

  function diff_entities_varlist () {
    local f1 f2
    f1=$(mktemp)
    f2=$(mktemp)
    sort_json_values ${1} | jq -M '.' > "$f1"
    sort_json_values ${2} | jq -M '.' > "$f2"
    diff -s --color "$f1" "$f2"
    rm "$f1" "$f2"
  }
  export -f diff_entities_varlist

  function vdiff_varlist_paths () {
    local f1 f2
    f1=$(mktemp)
    f2=$(mktemp)
    sort_json_values ${1} | jq -M -c 'paths(scalars) as $p | select(getpath($p[:-1]) | type == "array") | ($p[:-1] + [getpath($p)])' ${3} > "$f1"
    sort_json_values ${2} | jq -M -c 'paths(scalars) as $p | select(getpath($p[:-1]) | type == "array") | ($p[:-1] + [getpath($p)])' ${3} > "$f2"
    vimdiff "$f1" "$f2"
    rm "$f1" "$f2"
  }
  export -f vdiff_varlist_paths

  function diff_varlist_paths () {
    local f1 f2
    f1=$(mktemp)
    f2=$(mktemp)
    sort_json_values ${1} | jq -M -c 'paths(scalars) as $p | select(getpath($p[:-1]) | type == "array") | ($p[:-1] + [getpath($p)])' ${3} > "$f1"
    sort_json_values ${2} | jq -M -c 'paths(scalars) as $p | select(getpath($p[:-1]) | type == "array") | ($p[:-1] + [getpath($p)])' ${3} > "$f2"
    diff -s --color "$f1" "$f2"
    rm "$f1" "$f2"
  }
  export -f diff_varlist_paths

  function vdiff_basic () {
    local f1 f2
    f1=$(mktemp)
    f2=$(mktemp)
    jq -M '.' "$1" > "$f1"
    jq -M '.' "$2" > "$f2"
    vimdiff "$f1" "$f2"
    rm "$f1" "$f2"
  }
  export -f vdiff_basic

  function vdiff_paths () {
    local f1 f2
    f1=$(mktemp)
    f2=$(mktemp)
    jq -c 'paths' "$1" > "$f1"
    jq -c 'paths' "$2" > "$f2"
    vimdiff "$f1" "$f2"
    rm "$f1" "$f2"
  }
  export -f vdiff_paths

  function diff_paths () {
    diff -s --color \
      <(jq -c 'paths' "$1") \
      <(jq -c 'paths' "$2")
  }
  export -f diff_paths

  function diff_path_variable_entry () {
    local f1 f2
    f1=$(mktemp)
    f2=$(mktemp)
    jq -c 'paths' "$1" | awk -F',' '/variable_entry/ {if(NF==2) print $0}' | sort > "$f1"
    jq -c 'paths' "$2" | awk -F',' '/variable_entry/ {if(NF==2) print $0}' | sort > "$f2"
    diff -s --color "$f1" "$f2"
    rm "$f1" "$f2"
  }
  export -f diff_path_variable_entry

  function vdiff_path_variable_entry () {
    local f1 f2
    f1=$(mktemp)
    f2=$(mktemp)
    jq -c 'paths' "$1" | awk -F',' '/variable_entry/ {if(NF==2) print $0}' | sort > "$f1"
    jq -c 'paths' "$2" | awk -F',' '/variable_entry/ {if(NF==2) print $0}' | sort > "$f2"
    vimdiff "$f1" "$f2"
    rm "$f1" "$f2"
  }
  export -f vdiff_path_variable_entry

  function diff_jq_variable_entry () {
    local f1 f2
    f1=$(mktemp)
    f2=$(mktemp)
    jq '.variable_entry | to_entries | sort_by(.key) | from_entries' "$1" > "$f1"
    jq '.variable_entry | to_entries | sort_by(.key) | from_entries' "$2" > "$f2"
    diff -s --color "$f1" "$f2"
    rm "$f1" "$f2"
  }
  export -f diff_jq_variable_entry

  function vdiff_jq_variable_entry () {
    local f1 f2
    f1=$(mktemp)
    f2=$(mktemp)
    jq '.variable_entry | to_entries | sort_by(.key) | from_entries' "$1" > "$f1"
    jq '.variable_entry | to_entries | sort_by(.key) | from_entries' "$2" > "$f2"
    vimdiff "$f1" "$f2"
    rm "$f1" "$f2"
  }
  export -f vdiff_jq_variable_entry

  function vdiff_varlist_count () {
    local f1 f2
    f1=$(mktemp)
    f2=$(mktemp)
    jq -c 'paths' "$1" | awk -F',' '{gsub(/\[|\]/,"",$0); if(NF==3) print $0}' | cut -d',' -f1,2 | sort | uniq -c | sed -r 's/,/ /' | sort -k2,2 -k1,1 > "$f1"
    jq -c 'paths' "$2" | awk -F',' '{gsub(/\[|\]/,"",$0); if(NF==3) print $0}' | cut -d',' -f1,2 | sort | uniq -c | sed -r 's/,/ /' | sort -k2,2 -k1,1 > "$f2"
    vimdiff "$f1" "$f2"
    rm "$f1" "$f2"
  }
  export -f vdiff_varlist_count

compare_varlists() {
    # Compare two varlist JSON files with alphabetical sorting
    # Usage: compare_varlists file1.json file2.json [--vimdiff]

    local use_vimdiff=false
    local file1=""
    local file2=""

    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            --vimdiff|-v)
                use_vimdiff=true
                shift
                ;;
            *)
                if [ -z "$file1" ]; then
                    file1="$1"
                elif [ -z "$file2" ]; then
                    file2="$1"
                else
                    echo "Error: Too many arguments"
                    echo "Usage: compare_varlists file1.json file2.json [--vimdiff]"
                    return 1
                fi
                shift
                ;;
        esac
    done

    if [ -z "$file1" ] || [ -z "$file2" ]; then
        echo "Usage: compare_varlists file1.json file2.json [--vimdiff]"
        return 1
    fi

    if [ ! -f "$file1" ]; then
        echo "Error: $file1 not found"
        return 1
    fi

    if [ ! -f "$file2" ]; then
        echo "Error: $file2 not found"
        return 1
    fi

    # Create temp sorted files
    local temp1=$(mktemp --suffix=.json)
    local temp2=$(mktemp --suffix=.json)

    # Sort both files using Python
    python3 -c "
import json
import sys
from collections import OrderedDict

def sort_varlist(filename):
    with open(filename, 'r') as f:
        data = json.load(f)

    sorted_data = OrderedDict()
    for component in sorted(data.keys()):
        sorted_data[component] = OrderedDict()
        for table in sorted(data[component].keys()):
            sorted_data[component][table] = sorted(data[component][table])

    return sorted_data

sorted1 = sort_varlist('$file1')
sorted2 = sort_varlist('$file2')

with open('$temp1', 'w') as f:
    json.dump(sorted1, f, indent=4)
    f.write('\n')

with open('$temp2', 'w') as f:
    json.dump(sorted2, f, indent=4)
    f.write('\n')
"

    # Compare the sorted files
    echo "Comparing (both sorted alphabetically):"
    echo "  $file1"
    echo "  $file2"
    echo ""

    if [ "$use_vimdiff" = true ]; then
        # Open vimdiff
        vimdiff "$temp1" "$temp2"
        # After vimdiff closes, show diff summary
        echo ""
        echo "Summary of differences:"
        diff -u --color=always "$temp1" "$temp2" | head -50 || true
    else
        # Just show diff
        diff -u --color=always "$temp1" "$temp2" || true
    fi

    # Cleanup
    rm -f "$temp1" "$temp2"
}

  # Woffu to Trs
  function csvToJsonCompact () {
    qsv select 1,${2} ${1} | \
    sed -r 's/^.* ([[:digit:]]{2})\/([[:digit:]]{2})\/([[:digit:]]{4})/\3-\2\-\1/' | \
    awk 'BEGIN{FS=OFS=","}
    NR==1 {print $0; next}
    {
      gsub(/[a-z]/,"",$2)
      if($2 ~ /^[0-9]+ [0-9]+$/) {
        split($2, t, " ")
        $2 = sprintf("%.2f", t[1] + t[2]/60)
      } else if($2 ~ /^[0-9]+[ ]*$/) {
        $2 = sprintf("%.2f", $2)
      }
      if($2 != "") print $0
    }' | \
    python3 -c "import csv, json, sys; r = list(csv.reader(sys.stdin)); print(json.dumps([{'date': row[0], 'hours': float(row[1])} for row in r[1:]], separators=(',',':')))"
  }
  export -f csvToJsonCompact

  function dump_nc_variables () {
    ncdump -h "${1}" | rg '\(.*\) ;' | sed -r 's/.* (.*)\(.*/\1/' | paste -d' ' -s
  }
  export -f dump_nc_variables

  function vimrepl() {
      # Not inside tmux → start tmux session first
      if [ -z "$TMUX" ]; then
          tmux new-session -d -s vimrepl -n editor
          tmux split-window -v -t vimrepl
          tmux select-pane -t 1
          tmux send-keys -t 1 "vim \"$@\" -c 'norm ,va'" C-m
          tmux attach -t vimrepl
          return
      fi

      # Inside tmux
      panes=$(tmux list-panes | wc -l)

      if [ "$panes" -eq 1 ]; then
          tmux split-window -h
      fi

      vim "$@" -c "norm ,va"
  }
  export -f vimrepl

  function file_sizes_without_full_path() {
      # xargs reads from stdin (the pipe) and passes it to the rest of the chain
      xargs ls -ltr | awk '{print $5"/"$9}' | awk -F'/' '{print $1,$NF}' | sort | uniq -c
  }
  export -f file_sizes_without_full_path

  # Usage: replace_special_chars <file> [--dry-run]
  replace_special_chars() {
    local file="$1"
    local dry_run="${2:-}"

    if [[ ! -f "$file" ]]; then
      echo "File not found: $file" >&2
      return 1
    fi

    # Map of special char -> ASCII replacement.
    # Edit this table as you discover more characters.
    declare -A charmap=(
      ["—"]=" - "      # em dash (U+2014)
      ["–"]="-"        # en dash (U+2013)
      ["─"]="-"        # box drawing horizontal (U+2500)
      ["→"]="->"       # rightwards arrow (U+2192)
      ["…"]="..."      # ellipsis (U+2026)
      ["✓"]="[OK]"     # check mark (U+2713)
      ["✗"]="[FAIL]"   # ballot X (U+2717)
      ["’"]="'"        # right single quote (U+2019)
      ["“"]='"'        # left double quote (U+201C)
      ["”"]='"'        # right double quote (U+201D)
    )

    echo "== $file =="
    local found=0
    for char in "${!charmap[@]}"; do
      local count
      count=$(grep -o "$char" "$file" 2>/dev/null | wc -l)
      if [[ "$count" -gt 0 ]]; then
        found=1
        printf '  %-3s -> %-8s  (%d occurrences)\n' "$char" "${charmap[$char]}" "$count"
      fi
    done

    if [[ "$found" -eq 0 ]]; then
      echo "  (no mapped special characters found)"
      return 0
    fi

    if [[ "$dry_run" == "--dry-run" ]]; then
      echo "  [dry run, no changes made]"
      return 0
    fi

    cp "$file" "$file.bak"
    for char in "${!charmap[@]}"; do
      sed -i "s/$char/${charmap[$char]}/g" "$file"
    done
    echo "  done. backup saved to $file.bak"
  }
  export -f replace_special_chars

  # validate a .gitlab-ci.yml against the GitLab CI Lint API without
  # triggering a real pipeline. Checks YAML/schema correctness only --
  # does not run any job. Set GITLAB_HOST/GITLAB_TOKEN first.
  gitlab_lint() {
      local yaml_file="${1:-.gitlab-ci.yml}"
      local project_id="${2:?usage: gitlab_lint <path-to-yaml> <project-id>}"
      : "${GITLAB_HOST:?GITLAB_HOST not set (e.g. export GITLAB_HOST=gitlab.example.com)}"
      : "${GITLAB_TOKEN:?GITLAB_TOKEN not set}"

      python3 -c "import json; print(json.dumps({'content': open('$yaml_file').read()}))" \
        | curl --silent \
               --header "PRIVATE-TOKEN: ${GITLAB_TOKEN}" \
               --header "Content-Type: application/json" \
               --data @- \
               "https://${GITLAB_HOST}/api/v4/projects/${project_id}/ci/lint" \
        | jq .
  }
  export -f gitlab_lint

  # list recent CI pipelines for a project, optionally filtered by ref
  # (branch/tag name). Shows id/ref/status/created_at/web_url only --
  # follow up with gitlab_pipeline_jobs <project-id> <pipeline-id> to
  # see individual job status. Set GITLAB_HOST/GITLAB_TOKEN first.
  gitlab_pipelines() {
      local project_id="${1:?usage: gitlab_pipelines <project-id> [ref]}"
      local ref="${2:-}"
      : "${GITLAB_HOST:?GITLAB_HOST not set (e.g. export GITLAB_HOST=gitlab.example.com)}"
      : "${GITLAB_TOKEN:?GITLAB_TOKEN not set}"

      local url="https://${GITLAB_HOST}/api/v4/projects/${project_id}/pipelines?per_page=10"
      [[ -n "$ref" ]] && url="${url}&ref=${ref}"

      curl --silent --header "PRIVATE-TOKEN: ${GITLAB_TOKEN}" "$url" \
        | jq '[.[] | {id, ref, status, created_at, web_url}]'
  }
  export -f gitlab_pipelines

  # list jobs (with status) for a given pipeline id -- use to find the
  # job id of a failed job before calling gitlab_job_trace on it. Set
  # GITLAB_HOST/GITLAB_TOKEN first.
  gitlab_pipeline_jobs() {
      local project_id="${1:?usage: gitlab_pipeline_jobs <project-id> <pipeline-id>}"
      local pipeline_id="${2:?usage: gitlab_pipeline_jobs <project-id> <pipeline-id>}"
      : "${GITLAB_HOST:?GITLAB_HOST not set (e.g. export GITLAB_HOST=gitlab.example.com)}"
      : "${GITLAB_TOKEN:?GITLAB_TOKEN not set}"

      curl --silent --header "PRIVATE-TOKEN: ${GITLAB_TOKEN}" \
           "https://${GITLAB_HOST}/api/v4/projects/${project_id}/pipelines/${pipeline_id}/jobs" \
        | jq '[.[] | {id, name, stage, status}]'
  }
  export -f gitlab_pipeline_jobs

  # fetch the raw log (trace) for a single CI job id -- plain text, not
  # JSON, printed as-is. Set GITLAB_HOST/GITLAB_TOKEN first.
  gitlab_job_trace() {
      local project_id="${1:?usage: gitlab_job_trace <project-id> <job-id>}"
      local job_id="${2:?usage: gitlab_job_trace <project-id> <job-id>}"
      : "${GITLAB_HOST:?GITLAB_HOST not set (e.g. export GITLAB_HOST=gitlab.example.com)}"
      : "${GITLAB_TOKEN:?GITLAB_TOKEN not set}"

      curl --silent --header "PRIVATE-TOKEN: ${GITLAB_TOKEN}" \
           "https://${GITLAB_HOST}/api/v4/projects/${project_id}/jobs/${job_id}/trace"
  }
  export -f gitlab_job_trace

  # convenience wrapper: find the most recent pipeline (optionally for
  # a given ref) and dump the trace of every failed job in it, so you
  # don't have to chain gitlab_pipelines -> gitlab_pipeline_jobs ->
  # gitlab_job_trace by hand for the common "why did it just fail"
  # case. Set GITLAB_HOST/GITLAB_TOKEN first.
  gitlab_last_failure() {
      local project_id="${1:?usage: gitlab_last_failure <project-id> [ref]}"
      local ref="${2:-}"
      : "${GITLAB_HOST:?GITLAB_HOST not set (e.g. export GITLAB_HOST=gitlab.example.com)}"
      : "${GITLAB_TOKEN:?GITLAB_TOKEN not set}"

      local url="https://${GITLAB_HOST}/api/v4/projects/${project_id}/pipelines?per_page=1"
      [[ -n "$ref" ]] && url="${url}&ref=${ref}"

      local pipeline_id
      pipeline_id=$(curl --silent --header "PRIVATE-TOKEN: ${GITLAB_TOKEN}" "$url" | jq -r '.[0].id')
      if [[ -z "$pipeline_id" || "$pipeline_id" == "null" ]]; then
          echo "No pipeline found for ref '${ref:-<any>}'" >&2
          return 1
      fi
      echo "Pipeline: ${pipeline_id}"

      local failed_jobs
      failed_jobs=$(curl --silent --header "PRIVATE-TOKEN: ${GITLAB_TOKEN}" \
          "https://${GITLAB_HOST}/api/v4/projects/${project_id}/pipelines/${pipeline_id}/jobs" \
          | jq -c '[.[] | select(.status=="failed")]')

      local n
      n=$(echo "$failed_jobs" | jq 'length')
      if [[ "$n" -eq 0 ]]; then
          echo "No failed jobs in pipeline ${pipeline_id}."
          return 0
      fi

      local job_ids job_names
      mapfile -t job_ids < <(echo "$failed_jobs" | jq -r '.[].id')
      mapfile -t job_names < <(echo "$failed_jobs" | jq -r '.[].name')

      local i
      for i in "${!job_ids[@]}"; do
          echo
          echo "=== FAILED: ${job_names[$i]} (job ${job_ids[$i]}) ==="
          curl --silent --header "PRIVATE-TOKEN: ${GITLAB_TOKEN}" \
               "https://${GITLAB_HOST}/api/v4/projects/${project_id}/jobs/${job_ids[$i]}/trace"
      done
  }
  export -f gitlab_last_failure

  # create a new runner via the GitLab Runners API and print the
  # response (includes the one-time authentication token, glrt-...,
  # needed by gitlab_register_runner below). Registration tokens were
  # removed in GitLab 18.0 -- this is the only workflow that still
  # works. runner_type is one of project_type/group_type/instance_type;
  # target_id is the project or group id (omit/pass "" for
  # instance_type). Needs a token with the manage_runner (or api)
  # scope, not just read_api -- gitlab_pipelines/gitlab_lint's token
  # may not be enough on its own. Set GITLAB_HOST/GITLAB_TOKEN first.
  gitlab_create_runner() {
      local runner_type="${1:?usage: gitlab_create_runner <project_type|group_type|instance_type> <target-id-or-empty> <description> [tag_list] [run_untagged]}"
      local target_id="${2:-}"
      local description="${3:?description required}"
      local tag_list="${4:-}"
      local run_untagged="${5:-false}"
      : "${GITLAB_HOST:?GITLAB_HOST not set (e.g. export GITLAB_HOST=gitlab.example.com)}"
      : "${GITLAB_TOKEN:?GITLAB_TOKEN not set}"

      local data=(--data "runner_type=${runner_type}" --data "description=${description}" --data "run_untagged=${run_untagged}")
      case "$runner_type" in
          project_type) data+=(--data "project_id=${target_id}") ;;
          group_type)   data+=(--data "group_id=${target_id}") ;;
          instance_type) ;;
          *) echo "unknown runner_type: ${runner_type} (want project_type|group_type|instance_type)" >&2; return 1 ;;
      esac
      [[ -n "$tag_list" ]] && data+=(--data "tag_list=${tag_list}")

      echo "NOTE: the 'token' field below (glrt-...) is shown once here --" >&2
      echo "save it now, GitLab will not show it again." >&2

      curl --silent --request POST "${data[@]}" \
           --header "PRIVATE-TOKEN: ${GITLAB_TOKEN}" \
           "https://${GITLAB_HOST}/api/v4/user/runners" \
        | jq .
  }
  export -f gitlab_create_runner

  # register a runner locally using an authentication token from
  # gitlab_create_runner (or the GitLab UI's "New runner" page). Runs
  # gitlab-runner register on THIS host -- for a shell executor that
  # needs real host access, run this on the actual target machine, not
  # wherever you happen to be calling gitlab_create_runner from.
  # Needs sudo for system-mode registration (writes to
  # /etc/gitlab-runner/config.toml); without sudo it registers under
  # the invoking user's own config instead. Extra args after
  # description are passed through to gitlab-runner register as-is
  # (e.g. --tag-list "esgf-deploy" --locked=false --run-untagged=false).
  # Set GITLAB_HOST first.
  gitlab_register_runner() {
      local token="${1:?usage: gitlab_register_runner <auth-token> <executor> <description> [extra register args...]}"
      local executor="${2:?usage: gitlab_register_runner <auth-token> <executor> <description> [extra register args...]}"
      local description="${3:?description required}"
      shift 3
      : "${GITLAB_HOST:?GITLAB_HOST not set (e.g. export GITLAB_HOST=gitlab.example.com)}"

      sudo gitlab-runner register \
          --non-interactive \
          --url "https://${GITLAB_HOST}" \
          --token "${token}" \
          --executor "${executor}" \
          --description "${description}" \
          "$@"
  }
  export -f gitlab_register_runner

  # list runners visible to the authenticated user, optionally filtered
  # by tag. Shows id/description/active/is_shared/ip_address -- use to
  # find a runner_id before gitlab_enable_runner_for_project or
  # gitlab_project_runners. Set GITLAB_HOST/GITLAB_TOKEN first.
  gitlab_list_runners() {
      local tag="${1:-}"
      : "${GITLAB_HOST:?GITLAB_HOST not set (e.g. export GITLAB_HOST=gitlab.example.com)}"
      : "${GITLAB_TOKEN:?GITLAB_TOKEN not set}"

      local url="https://${GITLAB_HOST}/api/v4/runners?per_page=50"
      [[ -n "$tag" ]] && url="${url}&tag_list=${tag}"

      curl --silent --header "PRIVATE-TOKEN: ${GITLAB_TOKEN}" "$url" \
        | jq '[.[] | {id, description, active, is_shared, ip_address}]'
  }
  export -f gitlab_list_runners

  # full detail for a single runner id -- locked/run_untagged flags,
  # full tag_list, OS platform/architecture, and the list of projects
  # it's currently enabled for. Note: the GitLab API does NOT expose
  # executor type (shell vs docker vs ...) -- that's local to the
  # runner's own config.toml on the host, not GitLab-visible. Confirming
  # shell-vs-docker requires shell access to the host running the
  # runner (see node-deploy/diagnostics/check-gitlab-runner-persistence.sh),
  # not this function. Set GITLAB_HOST/GITLAB_TOKEN first.
  gitlab_runner_details() {
      local runner_id="${1:?usage: gitlab_runner_details <runner-id>}"
      : "${GITLAB_HOST:?GITLAB_HOST not set (e.g. export GITLAB_HOST=gitlab.example.com)}"
      : "${GITLAB_TOKEN:?GITLAB_TOKEN not set}"

      curl --silent --header "PRIVATE-TOKEN: ${GITLAB_TOKEN}" \
           "https://${GITLAB_HOST}/api/v4/runners/${runner_id}" \
        | jq '{id, description, locked, run_untagged, tag_list, platform, architecture, projects: [.projects[]? | {id, name}]}'
  }
  export -f gitlab_runner_details

  # list the runners currently enabled for a project -- the API
  # equivalent of Settings -> CI/CD -> Runners on a project. Set
  # GITLAB_HOST/GITLAB_TOKEN first.
  gitlab_project_runners() {
      local project_id="${1:?usage: gitlab_project_runners <project-id>}"
      : "${GITLAB_HOST:?GITLAB_HOST not set (e.g. export GITLAB_HOST=gitlab.example.com)}"
      : "${GITLAB_TOKEN:?GITLAB_TOKEN not set}"

      curl --silent --header "PRIVATE-TOKEN: ${GITLAB_TOKEN}" \
           "https://${GITLAB_HOST}/api/v4/projects/${project_id}/runners" \
        | jq '[.[] | {id, description, active, tag_list}]'
  }
  export -f gitlab_project_runners

  # enable an existing, unlocked runner for an additional project --
  # the API equivalent of the Settings -> CI/CD -> Runners "Enable for
  # this project" button. Only works if the runner's locked flag is
  # false (check with gitlab_runner_details first); a locked runner
  # returns a 4xx here and must be unlocked in the UI/API first. Set
  # GITLAB_HOST/GITLAB_TOKEN first.
  gitlab_enable_runner_for_project() {
      local project_id="${1:?usage: gitlab_enable_runner_for_project <project-id> <runner-id>}"
      local runner_id="${2:?usage: gitlab_enable_runner_for_project <project-id> <runner-id>}"
      : "${GITLAB_HOST:?GITLAB_HOST not set (e.g. export GITLAB_HOST=gitlab.example.com)}"
      : "${GITLAB_TOKEN:?GITLAB_TOKEN not set}"

      curl --silent --request POST \
           --header "PRIVATE-TOKEN: ${GITLAB_TOKEN}" \
           --header "Content-Type: application/json" \
           --data "{\"runner_id\": ${runner_id}}" \
           "https://${GITLAB_HOST}/api/v4/projects/${project_id}/runners" \
        | jq .
  }
  export -f gitlab_enable_runner_for_project

  # inverse of gitlab_enable_runner_for_project -- unassign a runner
  # from a project without deleting the runner itself. Set GITLAB_HOST/
  # GITLAB_TOKEN first.
  gitlab_disable_runner_for_project() {
      local project_id="${1:?usage: gitlab_disable_runner_for_project <project-id> <runner-id>}"
      local runner_id="${2:?usage: gitlab_disable_runner_for_project <project-id> <runner-id>}"
      : "${GITLAB_HOST:?GITLAB_HOST not set (e.g. export GITLAB_HOST=gitlab.example.com)}"
      : "${GITLAB_TOKEN:?GITLAB_TOKEN not set}"

      curl --silent --request DELETE \
           --header "PRIVATE-TOKEN: ${GITLAB_TOKEN}" \
           "https://${GITLAB_HOST}/api/v4/projects/${project_id}/runners/${runner_id}"
      echo "requested removal of runner ${runner_id} from project ${project_id}"
  }
  export -f gitlab_disable_runner_for_project

  # trigger a pipeline run via the API -- the equivalent of the
  # "Run pipeline" (web-source) button, without opening the UI. Prints
  # the new pipeline's id/status/web_url; follow up with
  # gitlab_pipelines/gitlab_last_failure to check on it. Extra args are
  # CI/CD variables as key=value pairs, passed through as
  # variables[key]=value form fields (e.g. to override a job's
  # variables: block for this one run). Set GITLAB_HOST/GITLAB_TOKEN
  # first.
  gitlab_run_pipeline() {
      local project_id="${1:?usage: gitlab_run_pipeline <project-id> <ref> [key=value ...]}"
      local ref="${2:?usage: gitlab_run_pipeline <project-id> <ref> [key=value ...]}"
      shift 2
      : "${GITLAB_HOST:?GITLAB_HOST not set (e.g. export GITLAB_HOST=gitlab.example.com)}"
      : "${GITLAB_TOKEN:?GITLAB_TOKEN not set}"

      local form=(--data-urlencode "ref=${ref}")
      local kv
      for kv in "$@"; do
          form+=(--data-urlencode "variables[][key]=${kv%%=*}")
          form+=(--data-urlencode "variables[][value]=${kv#*=}")
      done

      curl --silent --request POST \
           --header "PRIVATE-TOKEN: ${GITLAB_TOKEN}" \
           "${form[@]}" \
           "https://${GITLAB_HOST}/api/v4/projects/${project_id}/pipeline" \
        | jq '{id, status, web_url, ref}'
  }
  export -f gitlab_run_pipeline
