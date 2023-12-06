  " Propósito: convertir Rscripts en Rmd para editarlos manualmente después
  "
  "
  " espacios
  sil g/^\(#[a-z0-9()].*\)$\n^\([a-z].*\)$/s//\1\r\r\2/g

  " insertar código en bloques
  sil g/\(\(\%^\|^\n\)\zs[^#-]\(.\+\n\)*.\+\ze\(\n\n\|\n*\%$\)\)/s//```{r bloque_1}\1```/

  " eliminar linea vacia
  sil g/^$\n\(```\)$/s//\1/

  " agregar linea vacia
  sil g/^\([a-z].*\)\(```\)$/s//\1\r\2/

  " enumerar bloques
  let i=1 | sil g/\(bloque_\)1/s//\=submatch(1).printf('%04d',i)/ | let i+=1
