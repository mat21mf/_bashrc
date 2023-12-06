  #!/usr/bin/env R
  args = commandArgs(trailingOnly=TRUE)
  if (length(args)==0) {
    stop("Al menos un argumento debe ser suministrado.\n", call.=FALSE)
  }

  CsvAXlsx <- function( strcsv , strxls , strsht )
  {
    strdfm <- utils::read.csv(file=strcsv, sep=",", header=TRUE)
    openxlsx::write.xlsx( strdfm , file = strxls , sheetName=strsht )
  }

  if(!interactive()){
    strdfm  <-
    CsvAXlsx(
    strcsv  = args[1]
   ,strxls  = args[2]
   ,strsht  = args[3]
    )
  }
