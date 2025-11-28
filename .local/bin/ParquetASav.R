  #!/usr/bin/env R
  args = commandArgs(trailingOnly=TRUE)
  if (length(args)==0) {
    stop("Al menos un argumento debe ser suministrado.\n", call.=FALSE)
  }

  ParquetASav <- function( strinp , strout ){
      suppressPackageStartupMessages(library(arrow))
      suppressPackageStartupMessages(library(data.table))
      suppressPackageStartupMessages(library(haven))
      dfminp <- read_parquet( strinp )
      if(class( dfminp )[1] != "data.table" ) { setDT( dfminp ) }
      write_sav( dfminp , strout )
  }

  if(!interactive()){
    strout  <-
    ParquetASav(
    strinp  = args[1]
   ,strout  = args[2]
    )
  }
