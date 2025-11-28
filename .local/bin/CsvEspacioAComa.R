  #!/usr/bin/env R
  args = commandArgs(trailingOnly=TRUE)
  if (length(args)==0) {
    stop("Al menos un argumento debe ser suministrado.\n", call.=FALSE)
  }

  ComaAArroba <- function( strinpcsv , stroutcsv , strdfmcsv )
  {
    strdfmcsv <- read.csv( file = strinpcsv , header = F , sep = "" )
    write.table( strdfmcsv , file = stroutcsv , row.names = F , col.names = F , quote = F , sep = "," )
  }

  if(!interactive()){
    strdfmcsv  <-
    ComaAArroba(
    strinpcsv  = args[1]
   ,stroutcsv  = args[2]
   ,strdfmcsv  = args[3]
    )
  }
