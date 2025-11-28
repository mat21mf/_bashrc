
  " iniciar en posición centrada
  sil normal! zz

  " corregir bloques
  sil g/bloque_[0-9]\{4}/s//bloque_1/

  " enumerar bloques
  let i=1 | sil g/\(bloque_\)1/s//\=submatch(1).printf('%04d',i)/ | let i+=1

  " volver posición anterior
  sil normal! 
  sil normal! 
