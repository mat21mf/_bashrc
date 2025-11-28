  #!/usr/bin/env R
  args = commandArgs(trailingOnly=TRUE)
  if (length(args)==0) {
    stop("Al menos un argumento debe ser suministrado.\n", call.=FALSE)
  }

  ParquetAXlsx <- function( strinp , strout , strsht ){
      suppressPackageStartupMessages(library(arrow))
      suppressPackageStartupMessages(library(data.table))
      suppressPackageStartupMessages(library(openxlsx))
      dfminp <- read_parquet( strinp )
      if(class( dfminp )[1] != "data.table" ) { setDT( dfminp ) }
      if(strsht != ""){
          write.xlsx( dfminp , sheetName=strsht , strout )
      } else {
          write.xlsx( dfminp , strout )
      }
  }

  if(!interactive()){
    strout  <-
    ParquetAXlsx(
    strinp  = args[1]
   ,strout  = args[2]
   ,strsht  = args[3]
    )
  }
