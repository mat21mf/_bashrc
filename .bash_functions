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

