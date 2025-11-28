
sil normal V<cr>
sil '<,'>g/ *-\+$/s//}/
sil '<,'>g/\(.*\)/s//\L\1/g
sil '<,'>g/\([a-z]\)$/s//\1}/

let i=1
while i<=50
  sil '<,'>g/ /s//_/g
  sil '<,'>g/:/s//_/g
  sil '<,'>g/(/s//_/g
  sil '<,'>g/)/s//_/g
  sil '<,'>g/á/s//a/g
  sil '<,'>g/é/s//e/g
  sil '<,'>g/í/s//i/g
  sil '<,'>g/ó/s//o/g
  sil '<,'>g/ú/s//u/g
  sil '<,'>g/ñ/s//n/g
  sil '<,'>g/\(```{r\)_/s//\1 /
  let i+=1
endwhile
