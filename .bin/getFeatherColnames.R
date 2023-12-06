  #!/usr/bin/env R
  args = commandArgs(trailingOnly=TRUE)
  if (length(args)==0) {
    stop("Al menos un argumento debe ser suministrado.\n", call.=FALSE)
  }

  XlsxAParquet <- function( strxls )
  {
    suppressPackageStartupMessages(library(feather))
    objdfm <- feather(strxls)
    objcol <- paste0(colnames(objdfm), collapse = ",")
    print(paste(strxls, length(colnames(objdfm)), objcol, nrow(objdfm)))
    print(head(objdfm))
  }

  if(!interactive()){
    strdfm  <-
    XlsxAParquet(
    strxls  = args[1]
    )
  }
