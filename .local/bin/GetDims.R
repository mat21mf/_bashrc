  #!/usr/bin/env R
  args = commandArgs(trailingOnly=TRUE)
  if (length(args)==0) {
    stop("Al menos un argumento debe ser suministrado.\n", call.=FALSE)
  }

  GetDims <- function( strfle , ... )
  {
    suppressPackageStartupMessages(library(tools))
    suppressPackageStartupMessages(library(data.table))
    if( file_ext( strfle ) %in% "feather" ) {
      suppressPackageStartupMessages(library(feather))
      objdfm <- feather( strfle )
    }
    if( file_ext( strfle ) %in% "parquet" ) {
      suppressPackageStartupMessages(library(arrow))
      objdfm <- read_parquet( strfle )
    }
    if( file_ext( strfle ) %in% "xlsx" ) {
      suppressPackageStartupMessages(library(openxlsx))
      # if( missing(strsht) ){
        objdfm <- read.xlsx( strfle )
      # } else {
        # objdfm <- read.xlsx( strfle , sheet=strsht )
      # }
    }
    # setDT(objdfm)
    strmsg <- paste(strfle, ":", "Filas:", dim(objdfm)[1], "Columnas:", dim(objdfm)[2])
    return(print(strmsg))
  }

  if(!interactive()){
    objdfm  <-
    GetDims(
    strfle  = args[1]
    )
  }
