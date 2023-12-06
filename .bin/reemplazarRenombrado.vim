
let i=1
while i<=50
  sil g/\t\(.*\) /s//\t\1_/g
  sil g/\t\(.*\) /s//\t\1_/g
  sil g/\t\(.*\) /s//\t\1_/g
  sil g/\t\(.*\) /s//\t\1_/g
  sil g/\t\(.*\) /s//\t\1_/g
  sil g/\t\(.*\) /s//\t\1_/g
  sil g/\t\(.*\) /s//\t\1_/g
  sil g/\t\(.*\) /s//\t\1_/g
  sil g/\t\(.*\) /s//\t\1_/g
  sil g/\t\(.*\) /s//\t\1_/g
  let i+=1
endwhile
