  #!/usr/bin/env R
  args = commandArgs(trailingOnly=TRUE)
  if (length(args)==0) {
    stop("Al menos un argumento debe ser suministrado.\n", call.=FALSE)
  }

  MdbARds <- function( strmdb , strrds , strdfm )
  {
    if(!require(ImportExport)) install.packages("ImportExport")
    strdfm <- ImportExport::access_import(file=strmdb, table_names=strdfm)
    saveRDS( strdfm , file = strrds )
  }

  if(!interactive()){
    strdfm  <-
    MdbARds(
    strmdb  = args[1]
   ,strrds  = args[2]
   ,strdfm  = args[3]
    )
  }
