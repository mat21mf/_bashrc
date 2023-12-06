  #!/usr/bin/env R
  args = commandArgs(trailingOnly=TRUE)
  if (length(args)==0) {
    stop("Al menos un argumento debe ser suministrado.\n", call.=FALSE)
  }

  GetColnames <- function( strfle , strsht )
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
      if(( strsht == "" ) == TRUE ){
        objdfm <- read.xlsx( strfle )
      } else {
        objdfm <- read.xlsx( strfle , sheet=strsht )
      }
    }
    # setDT(objdfm)
    strcol <- colnames(objdfm)
    for(strinc in seq_along(strcol)){
      strmsg <- paste(strfle, ":", strcol[strinc])
      print(strmsg)
    }
  }

  if(!interactive()){
    objdfm  <-
    GetColnames(
    strfle  = args[1] ,
    strsht  = args[2]
    )
  }
