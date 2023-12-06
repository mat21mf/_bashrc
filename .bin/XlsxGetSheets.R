  #!/usr/bin/env R
  args = commandArgs(trailingOnly=TRUE)
  if (length(args)==0) {
    stop("Al menos un argumento debe ser suministrado.\n", call.=FALSE)
  }

  XlsxAParquet <- function( strxls )
  {
    suppressPackageStartupMessages(library(openxlsx))
    strsht <- openxlsx::getSheetNames(strxls)
    for(strinc in seq_along(strsht)){
      print(strsht[strinc])
    }
  }

  if(!interactive()){
    strdfm  <-
    XlsxAParquet(
    strxls  = args[1]
    )
  }
