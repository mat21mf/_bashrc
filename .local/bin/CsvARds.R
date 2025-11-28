  #!/usr/bin/env R
  args = commandArgs(trailingOnly=TRUE)
  if (length(args)==0) {
    stop("Al menos un argumento debe ser suministrado.\n", call.=FALSE)
  }

  CsvARds <- function( strcsv , strrds , strdfm )
  {
    strdfm <- utils::read.csv(file=strcsv, sep=",", header=TRUE)
    saveRDS( strdfm , file = strrds )
  }

  if(!interactive()){
    strdfm  <-
    CsvARds(
    strcsv  = args[1]
   ,strrds  = args[2]
   ,strdfm  = args[3]
    )
  }
